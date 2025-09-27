# Dotfile
My Linux config files

 <table>
  <tr>
    <th>File</th>
    <th>Location</th>
  </tr>
  <tr>
    <td>init.vim</td>
    <td>~/.config/nvim</td>
  </tr>
  <tr>
    <td>.tmux.conf</td>
    <td>~/</td>
  </tr>
    <tr>
    <td>.bashrc</td>
    <td>~/</td>
  </tr>
</table> 

## Installation Doumentation
> Prequesite : Must have a terminal with transparency option

1. Install neovim [VERSION 0.10 and above only]
2. Create both the config files
3. Paste the configuration files
4. Install vim plug and Run `:PlugInstall` in nvim
```
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
5. Install `nodejs` `npm` and `pyright`
```npm
yay -S nodejs npm
npm -g install 
```
6. Run `:Mason` to check if all 6 extensions are installed or not.
7. Install `tmux`
8. Clone ![tpm](https://github.com/tmux-plugins/tpm)
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
9. Install any nerd font
10. Inside tmux press `Ctrl + B` + `I`
> assuming that `Ctrl + B` is your prefix key


Mason Screen :

![image](https://github.com/user-attachments/assets/24e2c51f-e2ff-4bf4-b6e5-68bd2c89d51e)

<hr>

## Extentions
```
sudo apt install gnome-shell-extensions
```

[Clipboard Indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/)
[Dash to Panel](https://extensions.gnome.org/extension/1160/dash-to-panel/)
