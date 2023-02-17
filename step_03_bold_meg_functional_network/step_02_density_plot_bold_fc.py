import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd


def create_cmp():
    from matplotlib import cm
    from matplotlib.colors import ListedColormap
    blue = cm.get_cmap('Blues_r', 256)
    newcolors = blue(np.linspace(0.5, 0.85, 256))
    newcmp = ListedColormap(newcolors)
    return newcmp


def density_show(input_file,x_label,y_label,out_path):
    cmap = create_cmp()
    data = pd.read_csv(input_file)
    x, y = 'mat_b','mat_a'
    fig, ax = plt.subplots(figsize=(10, 12))
    sns.kdeplot(data=data, x=x, y=y, fill=True, levels=12, thresh=0.1, cmap=cmap, ax=ax)
    sns.regplot(data=data, x=x, y=y, scatter=False, color='steelblue', line_kws={'linewidth': '8'})
    ax.spines.right.set_visible(False)
    ax.spines.top.set_visible(False)
    x_left, x_right = -1.2, 1.2
    y_low, y_high = -0.1, 1.22
    ratio = 1.3
    fontsize = 43
    interval = 0.4
    ax.set_xlim([x_left, x_right])
    ax.set_ylim([y_low, y_high])
    ax.set_aspect(abs((x_right - x_left) / (y_low - y_high)) * ratio)
    ax.set_xlabel(x_label, fontsize=fontsize, fontname='Arial')
    ax.set_ylabel(y_label, fontsize=fontsize, fontname='Arial')
    ax.set_xticks(np.arange(-1, 1.1, 0.5))
    ax.set_yticks(np.arange(0 , 1.21, interval), fontsize=fontsize, fontname='Arial')
    fig.subplots_adjust(
        top=0.981,
        bottom=0.12,
        left=0.22,
        right=0.9,
        hspace=0.2,
        wspace=0.2
    )
    for tick in ax.xaxis.get_major_ticks():
        tick.label.set_fontsize(fontsize)
        tick.label.set_fontname('Arial')
    for tick in ax.yaxis.get_major_ticks():
        tick.label.set_fontsize(fontsize)
        tick.label.set_fontname('Arial')
    for _, s in ax.spines.items():
        s.set_color('black')
        s.set_linewidth(3)
    # plt.show()
    plt.savefig(out_path, dpi=300)


if __name__ == '__main__':
    file_path = 'F:/Cui_Lab/Projects/Connectional_Hierarchy/step_03_bold_meg_functional_network'
    x_label = 'BOLD FC' 
    y_label = 'FC variability'
    
    input_file = file_path + '/hcpd_fc_variability_fc_hcpd.csv'       
    out_path = file_path + '/density_plot_hcpd_schaefer400.png'   
    density_show(input_file,x_label,y_label,out_path)   

    input_file = file_path + '/hcp_fc_variability_fc_hcp.csv'       
    out_path = file_path + '/density_plot_hcp_schaefer400.png'   
    density_show(input_file,x_label,y_label,out_path)
