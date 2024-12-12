class ReactGenerator < Rails::Generators::Base
  def use_typescript
    gsub_file 'app/views/layouts/application.html.erb', "<%= vite_javascript_tag 'application' %>",
              "<%= vite_react_refresh_tag %>\n<%= vite_typescript_tag 'application' %>"
    create_file 'tsconfig.json', <<~JSON
          {
        "compilerOptions": {
          "declaration": false,
          "skipLibCheck": true,
          "module": "esnext",
          "moduleResolution": "node",
          "sourceMap": true,
          "target": "es2016",
          "jsx": "react-jsx",
          "noEmit": true,
          "allowSyntheticDefaultImports": true,
          "resolveJsonModule": true,
          "isolatedModules": true,
          "esModuleInterop": true,
          "forceConsistentCasingInFileNames": true,
          "baseUrl": ".",
          "paths": {
            "@/*": [
              "app/frontend/*"
            ],
            "*": [
              "node_modules/*"
            ]
          }
        },
        "exclude": [
          "**/*.spec.ts",
          "node_modules",
          "vendor",
          "public"
        ],
        "compileOnSave": false
      }
    JSON
  end

  def add_javascript_packages
    run 'npm install react react-dom @vitejs/plugin-react @types/react'
  end

  def vite_config_settings
    remove_file 'vite.config.ts'
    create_file 'vite.config.ts', <<~VITE
      import { defineConfig } from 'vite'
      import RubyPlugin from 'vite-plugin-ruby'
      import ReactPlugin from "@vitejs/plugin-react";
      export default defineConfig({
        plugins: [
          RubyPlugin(), ReactPlugin()],
      })

    VITE
  end

  def rename_application_js
    run 'mv app/javascript/entrypoints/application.js app/javascript/entrypoints/application.ts'
  end

  # def set_root_route
  #   route "root to: 'components#index'"
  #   route "get '*page', to: 'components#index', constraints: ->(req) { !req.xhr? && req.format.html? }"
  # end

  # def define_root
  #   create_file 'app/views/components/index.html.erb', <<~HTML
  #     <div id="root"></div>
  #   HTML
  # end

  # def inital_controller
  #   generate(:controller, 'components', 'index')
  # end

  def fix_tailwind
    gsub_file 'config/tailwind.config.js', /\.js/, '.{ts,tsx}'
  end

  # def create_and_import_app_ts
  #   create_file 'app/frontend/App.tsx', <<~TSX
  #     import React from "react";
  #     import { createRoot } from "react-dom/client";

  #     const App = () => {
  #         return (
  #             <React.StrictMode>
  #                <p>hello, world!</p>
  #             </React.StrictMode>
  #         );
  #     };

  #     document.addEventListener("DOMContentLoaded", () => {
  #         const root = createRoot(document.getElementById("root"));
  #         root.render(<App />);
  #     });
  #   TSX

  #   append_to_file 'app/frontend/entrypoints/application.ts', <<~TS
  #     import '../App.tsx';
  #   TS
  # end

  def move_imports_to_entrypoints
    append_to_file 'app/javascript/entrypoints/application.ts', <<~JS
      import "@hotwired/turbo-rails"
      import "controllers"
    JS

    remove_file 'app/javascript/application.js'
  end
end
