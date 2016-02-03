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

# формирование сообщения об ошибке
# @error - переменная с текстом об ошибке, выводится в соответствующем вью
# получает хеш и проверяет если в нем есть пустой ключ то добавляется соотв значение
def set_error hh
  @error = hh.select { |key,_| params[key] == ''}.values.join('. ')
end


# прежде всего поместить в переменную все записи барберов
before do
	@barbers = Barber.all
end

# что выводить на корневой странице
get '/' do
	# в переменную внести все записи из сущности Барбер отсортированных
	@barbers = Barber.order "created_at DESC"
	erb :index
end

# страница записи на стрижку
get '/visit' do
	erb :visit
end

# обработка страницы записи
post '/visit' do

	# сохраняем параметры в переменные
	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	# создание хэша для вызова функции по формированию отчета об ошибках
	hh = {
		:username => 'Представься',
		:phone => 'Введи номер телефона',
		:datetime => 'Введи дату и время'
	}
	set_error hh

	# если в переменной еррор что-то есть то выводим эту же страницу с сообщ об ошибках
	return erb :visit if @error != ''

	# сохраняем переменные в БД
	Client.create :name => @username,:phone => @phone,:datestamp => @datetime,:barber => @barber,:color => @color

	erb 'Спасибо за запись'
end
