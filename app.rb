#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

# инициализация БД
set :database, "sqlite3:barbershop.db"

# создание сущности Клиент
class Client < ActiveRecord::Base
end

# создание сущности Барбер
class Barber < ActiveRecord::Base
end

# что выводить на корневой странице
get '/' do
	# в переменную внести все записи из сущности Барбер
	@barbers = Barber.all
	erb :index
end
