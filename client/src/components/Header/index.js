import React from 'react';
import styles from './header.module.scss';

const Header = () => (
  <div className={styles.header}>
    <nav id="menu" className="menu">
      <ul>
        <li><a href="/" className={styles.link}><span style={{ padding: "60px" }}> Home </span></a></li>

        <li><a href="/idle-insurance-fund" className={styles.link}> idle Insurance Fund</a></li>
      </ul>
    </nav>
  </div>
)

export default Header;
