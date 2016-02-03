#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

# инициализация БД
set :database, "sqlite3:barbershop.db"

# создание сущности Клиент
class Client < ActiveRecord::Base
	# валидация - эти поля должны быть не пустыми
	validates :name, presence: true, length: {minimum: 3}
	validates :phone, presence: true
	validates :datestamp, presence: true
	validates :color, presence: true
end

# создание сущности Барбер
class Barber < ActiveRecord::Base
end

# создание сущности клиентских сообщений
class Message < ActiveRecord::Base
	validates :mail, presence: true
	validates :msg, presence: true
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
	@c = Client.new
	erb :visit
end

# страница контаков
get '/contacts' do
	erb :contacts
end

# обработка страницы записи
post '/visit' do
	# сохраняем переменные в БД
	@c = Client.new params[:client]
	@c.save

	if @c.save
		erb 'Спасибо за запись'
	else
		@error = @c.errors.full_messages.first
		erb :visit
	end

end

# обработка страницы контакты
post '/contacts' do
	# сохраняем переменные в БД
	@m = Message.new params[:message]
	@m.save

	erb 'Сообщение отправлено'
end
