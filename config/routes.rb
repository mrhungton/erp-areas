Erp::Areas::Engine.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
		namespace :backend, module: "backend", path: "backend/areas" do
			resources :countries do
				collection do
					post 'list'
					post 'dataselect'
					delete 'delete_all'
					put 'archive_all'
					put 'unarchive_all'
					put 'archive'
					put 'unarchive'
				end
			end
			resources :states do
				collection do
					post 'list'
					post 'dataselect'
					delete 'delete_all'
					put 'archive_all'
					put 'unarchive_all'
					put 'archive'
					put 'unarchive'
				end
			end
			resources :districts do
				collection do
					post 'list'
					post 'dataselect'
				end
			end
		end
	end
end