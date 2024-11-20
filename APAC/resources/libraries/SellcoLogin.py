from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
import os
import autoit
import sys

class SellcoLogin:

	def login_to_sellco(self, sellco_username, sellco_password):
		os.system('taskkill /f /im "chromedriver.exe"')
		os.system('taskkill /f /im "chrome.exe"')
		os.system('taskkill /f /im "AmadeusSmartScriptingBridge.exe"')
		bridge = 'AmadeusSmartScriptingBridge.exe'
		os.chdir('C:\\Amadeus\\Amadeus Smart Scripting Bridge\\')
		autoit.run(bridge)
		
		options = webdriver.ChromeOptions()
		options.add_experimental_option("detach", True)
		driver = webdriver.Chrome(chrome_options=options)
		wait = WebDriverWait(driver, 120)
		driver.get("https://acceptance.custom.sellingplatformconnect.amadeus.com/LoginService/")
		driver.maximize_window()
		
		username = wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, "#username > span:first-child input")))
		
		try:
			accept_cookie = WebDriverWait(driver, 30).until(EC.presence_of_element_located((By.XPATH, "//div[@class='accept']//button")))
			accept_cookie.click()
		except Exception:
			pass
		
		username.send_keys(sellco_username)
		driver.find_element_by_css_selector("#dutyCode .xTextInputInput").send_keys("su")
		driver.find_element_by_css_selector(".officeId .xTextInputInput").send_keys('BLRWL22MS')	
		driver.find_element_by_css_selector("#password span:first-child input").send_keys(sellco_password)
		wait.until(EC.invisibility_of_element_located((By.CSS_SELECTOR, "div#logi_confirmButton .xButtonDisabled")))
		submit_button = wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, "#logi_confirmButton .xButton")))
		submit_button.click()
		
		try:
			force_login = WebDriverWait(driver, 30).until(EC.presence_of_element_located((By.XPATH, "//span[contains(text(), 'Force Sign In')]")))
			force_login.click()
		except Exception:
			pass
		
		wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, ".uicTaskbarText")))
		
		try:
			accept_cookie = WebDriverWait(driver, 30).until(EC.presence_of_element_located((By.XPATH, "//div[@class='accept']//button")))
			accept_cookie.click()
		except Exception:
			pass