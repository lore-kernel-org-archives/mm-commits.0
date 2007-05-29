From: akpm@linux-foundation.org
Subject: - update-dontdiff-file.patch removed from -mm tree
Date: Tue, 29 May 2007 11:52:17 -0700
Message-ID: <200705291852.l4TIqGuD008395@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758160AbXE2SxF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:53:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     update dontdiff file
has been removed from the -mm tree.  Its filename was
     update-dontdiff-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: update dontdiff file
From: Randy Dunlap <randy.dunlap@oracle.com>

Update dontdiff file by adding entries from many .gitignore files.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dontdiff |   42 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 41 insertions(+), 1 deletion(-)

diff -puN Documentation/dontdiff~update-dontdiff-file Documentation/dontdiff
--- a/Documentation/dontdiff~update-dontdiff-file
+++ a/Documentation/dontdiff
@@ -10,10 +10,12 @@
 *.grp
 *.gz
 *.html
+*.i
 *.jpeg
 *.ko
 *.log
 *.lst
+*.moc
 *.mod.c
 *.o
 *.orig
@@ -25,6 +27,9 @@
 *.s
 *.sgml
 *.so
+*.symtypes
+*.tab.c
+*.tab.h
 *.tex
 *.ver
 *.xml
@@ -32,9 +37,13 @@
 *_vga16.c
 *cscope*
 *~
+*.9
+*.9.gz
 .*
 .cscope
 53c700_d.h
+53c7xx_d.h
+53c7xx_u.h
 53c8xx_d.h*
 BitKeeper
 COPYING
@@ -70,9 +79,11 @@ bzImage*
 classlist.h*
 comp*.log
 compile.h*
+conf
 config
 config-*
 config_data.h*
+config_data.gz*
 conmakehash
 consolemap_deftbl.c*
 crc32table.h*
@@ -81,18 +92,23 @@ defkeymap.c*
 devlist.h*
 docproc
 dummy_sym.c*
+elf2ecoff
 elfconfig.h*
 filelist
 fixdep
 fore200e_mkfirm
 fore200e_pca_fw.c*
+gconf
 gen-devlist
 gen-kdb_cmds.c*
 gen_crc32table
 gen_init_cpio
 genksyms
 gentbl
+*_gray256.c
 ikconfig.h*
+initramfs_data.cpio
+initramfs_data.cpio.gz
 initramfs_list
 kallsyms
 kconfig
@@ -100,19 +116,30 @@ kconfig.tk
 keywords.c*
 ksym.c*
 ksym.h*
+kxgettext
+lkc_defs.h
 lex.c*
+lex.*.c
+lk201-map.c
 logo_*.c
 logo_*_clut224.c
 logo_*_mono.c
 lxdialog
 mach-types
 mach-types.h
+machtypes.h
 make_times_h
 map
 maui_boot.h
+mconf
+miboot*
 mk_elfconfig
+mkboot
+mkbugboot
 mkdep
+mkprep
 mktables
+mktree
 modpost
 modversions.h*
 offset.h
@@ -120,18 +147,28 @@ offsets.h
 oui.c*
 parse.c*
 parse.h*
+patches*
+pca200e.bin
+pca200e_ecd.bin2
+piggy.gz
+piggyback
 pnmtologo
 ppc_defs.h*
 promcon_tbl.c*
 pss_boot.h
+qconf
 raid6altivec*.c
 raid6int*.c
 raid6tables.c
+relocs
+series
 setup
 sim710_d.h*
+sImage
 sm_tbl*
 split-include
 tags
+tftpboot.img
 times.h*
 tkparse
 trix_boot.h
@@ -139,8 +176,11 @@ utsrelease.h*
 version.h*
 vmlinux
 vmlinux-*
+vmlinux.aout
 vmlinux.lds
 vsyscall.lds
 wanxlfw.inc
 uImage
-zImage
+unifdef
+zImage*
+zconf.hash.c
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
add-pci_try_set_mwi-prism54pci.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
add-notime-boot-option.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
