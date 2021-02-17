import React from 'react'
import { Link } from 'react-router-dom'
import Logo from '../../../assets/logo2.png'
import Button from '../Button/Button'
import css from './Navbar.module.scss'

const Navbar = () => (
  <div className={css.root}>
    <Link to="/">
      <img
        alt="Library Management System"
        className={css.logo}
        src={Logo}
      />
    </Link>
    <div className={css.menu}>
      <Link to="/" className={css.link}>
        Books
      </Link>
      <Link to="/books/new" className={css.link}>
        <Button style={css.addBook} kind="brand">
          Add Book
        </Button>
      </Link>
    </div>
  </div>
);

export default Navbar

