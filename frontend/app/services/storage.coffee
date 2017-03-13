

app = angular.module('app')

app.factory "Storage", ['APP',(APP) ->

	storage =

		active: true

		name: 'breeders-project'

		has: (key,islocalstorage) ->

			return false if !@active or !localStorage? or !sessionStorage?

			if islocalstorage

				return false if !localStorage.getItem(@name)?
				data = JSON.parse(localStorage.getItem(@name))

			else

				return false if !sessionStorage.getItem(@name)?
				data = JSON.parse(sessionStorage.getItem(@name))

			return data.hasOwnProperty(key)

		set: (key,value,islocalstorage) ->

			return if !@active or !localStorage? or !sessionStorage?

			if islocalstorage

				if !localStorage.getItem(@name)
					data = {}
				else
					data = JSON.parse(localStorage.getItem(@name))

				data[key] = value
				data['dateSet'] = new Date() # дата установки
				localStorage.setItem(@name,JSON.stringify(data))

			else

				if !sessionStorage.getItem(@name)
					data = {}
				else
					data = JSON.parse(sessionStorage.getItem(@name))

				data[key] = value
				data['dateSet'] = new Date() # дата установки
				sessionStorage.setItem(@name,JSON.stringify(data))


			return

		get: (key,islocalstorage) ->

			return null if !@active or !localStorage? or !sessionStorage?

			if islocalstorage
				data = @getAll(true)

			else
				data = @getAll()

			return if data and data.hasOwnProperty(key) then data[key] else null


		getAll: (islocalstorage) ->

			return null if !@active or !localStorage? or !sessionStorage?

			if islocalstorage

				return null if !localStorage.getItem(@name)?
				data = JSON.parse(localStorage.getItem(@name))

			else
				return null if !sessionStorage.getItem(@name)?
				data = JSON.parse(sessionStorage.getItem(@name))

			return data

		clear: (key,islocalstorage) ->

			return if !@active or !localStorage? or !sessionStorage?

			if islocalstorage

				data = @getAll(true)
				delete data[key] if data[key]
				localStorage.setItem(@name,JSON.stringify(data))

			else

				data = @getAll()
				delete data[key] if data[key]
				sessionStorage.setItem(@name,JSON.stringify(data))


			return

		clearAll: (islocalstorage) ->

			return if !@active or !localStorage? or !sessionStorage?

			if islocalstorage
				localStorage.removeItem(@name)

			else
				sessionStorage.removeItem(@name)

			return

	# storage.clear()
	# sessionStorage.clear()

	return storage

]