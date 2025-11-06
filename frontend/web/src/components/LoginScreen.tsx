'use client';

export default function LoginScreen() {
  return (
    <div className="login-container">
      {/* iOS Status Bar */}
      <div className="status-bar">
        <div className="status-bar-content">
          <div className="time-display">9:41</div>
          <div className="status-icons">
            <svg className="cellular-signal" width="80" height="13" viewBox="0 0 80 13" fill="none">
              <path fillRule="evenodd" clipRule="evenodd" d="M19.2 1.53302C19.2 0.899974 18.7224 0.386791 18.1333 0.386791H17.0667C16.4776 0.386791 16 0.899974 16 1.53302V11.467C16 12.1 16.4776 12.6132 17.0667 12.6132H18.1333C18.7224 12.6132 19.2 12.1 19.2 11.467V1.53302ZM11.7659 2.83207H12.8326C13.4217 2.83207 13.8992 3.35757 13.8992 4.00581V11.4395C13.8992 12.0877 13.4217 12.6132 12.8326 12.6132H11.7659C11.1768 12.6132 10.6992 12.0877 10.6992 11.4395V4.00581C10.6992 3.35757 11.1768 2.83207 11.7659 2.83207ZM7.43411 5.48112H6.36745C5.77834 5.48112 5.30078 6.01331 5.30078 6.6698V11.4245C5.30078 12.081 5.77834 12.6132 6.36745 12.6132H7.43411C8.02322 12.6132 8.50078 12.081 8.50078 11.4245V6.6698C8.50078 6.01331 8.02322 5.48112 7.43411 5.48112ZM2.13333 7.92641H1.06667C0.477563 7.92641 0 8.451 0 9.09811V11.4415C0 12.0886 0.477563 12.6132 1.06667 12.6132H2.13333C2.72244 12.6132 3.2 12.0886 3.2 11.4415V9.09811C3.2 8.451 2.72244 7.92641 2.13333 7.92641Z" fill="#4B4B4B"/>
              <path fillRule="evenodd" clipRule="evenodd" d="M35.7713 2.80213C38.2584 2.80223 40.6504 3.72432 42.4529 5.3778C42.5886 5.50545 42.8056 5.50384 42.9393 5.37419L44.2367 4.11072C44.3044 4.04496 44.3422 3.95588 44.3416 3.8632C44.3411 3.77052 44.3022 3.68187 44.2338 3.61688C39.5027 -0.757833 32.039 -0.757833 27.308 3.61688C27.2395 3.68183 27.2006 3.77044 27.2 3.86313C27.1993 3.95581 27.237 4.04491 27.3046 4.11072L28.6025 5.37419C28.7361 5.50404 28.9532 5.50565 29.0889 5.3778C30.8916 3.72421 33.2839 2.80212 35.7713 2.80213ZM35.7679 7.0224C37.1252 7.02232 38.4341 7.53406 39.4402 8.45819C39.5763 8.58934 39.7907 8.5865 39.9233 8.45178L41.2106 7.13247C41.2784 7.06327 41.316 6.96939 41.315 6.87184C41.3141 6.77429 41.2746 6.68121 41.2054 6.61342C38.1416 3.72257 33.3968 3.72257 30.333 6.61342C30.2638 6.68121 30.2243 6.77434 30.2234 6.87192C30.2225 6.9695 30.2602 7.06337 30.3282 7.13247L31.6151 8.45178C31.7477 8.5865 31.9621 8.58934 32.0982 8.45819C33.1036 7.53467 34.4115 7.02297 35.7679 7.0224ZM38.2923 9.81596C38.2942 9.9213 38.2572 10.0229 38.1899 10.0967L36.0132 12.5514C35.9494 12.6236 35.8624 12.6642 35.7717 12.6642C35.6809 12.6642 35.5939 12.6236 35.5301 12.5514L33.3531 10.0967C33.2858 10.0228 33.2488 9.92122 33.2508 9.81587C33.2528 9.71052 33.2936 9.61075 33.3636 9.54014C34.7537 8.22625 36.7896 8.22625 38.1797 9.54014C38.2497 9.61081 38.2904 9.7106 38.2923 9.81596Z" fill="#4B4B4B"/>
              <rect opacity="0.35" x="52.8417" y="0.5" width="24" height="12" rx="3.8" stroke="#4B4B4B"/>
              <path opacity="0.4" d="M78.3417 4.78113V8.8566C79.1464 8.51143 79.6697 7.70847 79.6697 6.81886C79.6697 5.92926 79.1464 5.1263 78.3417 4.78113Z" fill="#4B4B4B"/>
              <rect x="54.3417" y="2" width="21" height="9" rx="2.5" fill="#4B4B4B"/>
            </svg>
          </div>
        </div>
        <svg className="notch" width="165" height="29" viewBox="0 0 165 29" fill="none">
          <path d="M0 0H165C163.393 0.590077 162.309 2.1012 162.265 3.81252L162.225 5.3764C162.225 18.4234 151.648 29 138.601 29H26.3988C13.3519 29 2.77523 18.4234 2.77523 5.3764L2.73502 3.81252C2.69102 2.1012 1.60697 0.590077 0 0Z" fill="#020202"/>
        </svg>
      </div>

      {/* Cloud Icon */}
      <div className="cloud-icon-wrapper">
        <img 
          src="https://api.builder.io/api/v1/image/assets/TEMP/023d44c8f5061cf50346400826a692dea1278e0c?width=450" 
          alt="Cloud with flag" 
          className="cloud-icon"
        />
      </div>

      {/* Login Card */}
      <div className="login-card">
        <h1 className="login-title">Log In</h1>
        
        <div className="form-container">
          <div className="input-wrapper">
            <input 
              type="email" 
              placeholder="Email" 
              className="input-field"
            />
          </div>
          
          <div className="input-wrapper">
            <input 
              type="password" 
              placeholder="Password" 
              className="input-field"
            />
          </div>
          
          <a href="#" className="forgot-password-link">
            forgot password?
          </a>
          
          <button className="login-button">
            Login
          </button>
          
          <div className="signup-prompt">
            <span className="signup-text">Don't have an account? </span>
            <a href="/signup" className="signup-link">Sign Up</a>
          </div>
        </div>
      </div>

      {/* Home Indicator */}
      <div className="home-indicator-wrapper">
        <div className="home-indicator-container">
          <div className="home-indicator-bar"></div>
        </div>
      </div>

      <style jsx>{`
        .login-container {
          width: 375px;
          height: 812px;
          background: #85C9F4;
          position: relative;
          overflow: hidden;
          margin: 0 auto;
        }

        .status-bar {
          width: 375px;
          height: 48px;
          position: absolute;
          left: 0;
          top: 0;
        }

        .status-bar-content {
          display: flex;
          width: 375px;
          padding: 13px 16px 13px 32px;
          justify-content: space-between;
          align-items: center;
          position: absolute;
          left: 0;
          top: 0;
          height: 48px;
        }

        .time-display {
          color: #4B4B4B;
          text-align: center;
          font-family: 'SF Pro Text', -apple-system, Roboto, Helvetica, sans-serif;
          font-size: 17px;
          font-weight: 600;
          line-height: 22px;
        }

        .status-icons {
          display: flex;
          align-items: center;
        }

        .cellular-signal {
          display: flex;
          align-items: center;
          gap: 8px;
        }

        .notch {
          width: 165px;
          height: 29px;
          position: absolute;
          left: 105px;
          top: 0;
        }

        .cloud-icon-wrapper {
          position: absolute;
          left: 74px;
          top: 48px;
          width: 225px;
          height: 225px;
        }

        .cloud-icon {
          width: 100%;
          height: 100%;
          object-fit: contain;
        }

        .login-card {
          width: 375px;
          height: 496px;
          border-radius: 40px 40px 0 0;
          background: #F2F5FF;
          box-shadow: 0 4px 4px 0 rgba(0, 0, 0, 0.25);
          position: absolute;
          left: 0;
          top: 289px;
        }

        .login-title {
          color: #50A6DD;
          text-shadow: 0 4px 4px rgba(0, 0, 0, 0.25);
          font-family: Outfit, -apple-system, Roboto, Helvetica, sans-serif;
          font-size: 40px;
          font-weight: 600;
          position: absolute;
          left: 132px;
          top: 24px;
          margin: 0;
        }

        .form-container {
          position: absolute;
          top: 106px;
          left: 20px;
          width: 335px;
        }

        .input-wrapper {
          margin-bottom: 80px;
        }

        .input-wrapper:first-child {
          margin-bottom: 80px;
        }

        .input-wrapper:nth-child(2) {
          margin-bottom: 58px;
        }

        .input-field {
          width: 335px;
          height: 50px;
          border-radius: 27px;
          background: #FFF;
          box-shadow: 0 4px 4px 0 rgba(0, 0, 0, 0.25);
          border: none;
          padding: 0 46px;
          font-family: Outfit, -apple-system, Roboto, Helvetica, sans-serif;
          font-size: 20px;
          font-weight: 400;
          outline: none;
        }

        .input-field::placeholder {
          color: #C5C0C0;
        }

        .forgot-password-link {
          color: #50A6DD;
          font-family: Outfit, -apple-system, Roboto, Helvetica, sans-serif;
          font-size: 14px;
          font-weight: 400;
          text-decoration: none;
          position: absolute;
          right: 0;
          top: 244px;
        }

        .login-button {
          width: 335px;
          height: 56px;
          border-radius: 27px;
          background: #2B97E0;
          box-shadow: 0 4px 4px 0 rgba(0, 0, 0, 0.25);
          border: none;
          color: #FFF;
          font-family: Outfit, -apple-system, Roboto, Helvetica, sans-serif;
          font-size: 24px;
          font-weight: 400;
          cursor: pointer;
          margin-top: 58px;
        }

        .signup-prompt {
          text-align: center;
          margin-top: 47px;
        }

        .signup-text {
          color: #000;
          font-family: Outfit, -apple-system, Roboto, Helvetica, sans-serif;
          font-size: 14px;
          font-weight: 400;
        }

        .signup-link {
          color: #50A6DD;
          font-family: Outfit, -apple-system, Roboto, Helvetica, sans-serif;
          font-size: 14px;
          font-weight: 600;
          text-decoration: none;
        }

        .home-indicator-wrapper {
          display: flex;
          width: 375px;
          flex-direction: column;
          align-items: flex-start;
          background: #F5F5F5;
          position: absolute;
          left: 0;
          top: 785px;
          height: 27px;
        }

        .home-indicator-container {
          display: flex;
          height: 27px;
          padding: 13px 114px;
          flex-direction: column;
          align-items: flex-start;
          gap: 9px;
          width: 100%;
          background: #F2F5FF;
        }

        .home-indicator-bar {
          width: 147px;
          height: 5px;
          border-radius: 2.5px;
          background: rgba(26, 26, 26, 0.66);
        }

        @media (max-width: 375px) {
          .login-container {
            width: 100%;
          }
          
          .status-bar,
          .status-bar-content,
          .login-card,
          .home-indicator-wrapper {
            width: 100%;
          }
        }
      `}</style>
    </div>
  );
}
