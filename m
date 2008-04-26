From: akpm@linux-foundation.org
Subject: - tags-add-menuconfig-symbols-as-well.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:40:46 -0700
Message-ID: <200804261640.m3QGekkx031060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757271AbYDZQt1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:49:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     tags: add menuconfig symbols as well
has been removed from the -mm tree.  Its filename was
     tags-add-menuconfig-symbols-as-well.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tags: add menuconfig symbols as well
From: Alexey Dobriyan <adobriyan@gmail.com>

Steps to reproduce:

	vi -t NETFILTER

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Makefile~tags-add-menuconfig-symbols-as-well Makefile
--- a/Makefile~tags-add-menuconfig-symbols-as-well
+++ a/Makefile
@@ -1396,7 +1396,7 @@ define xtags
 	    $(all-kconfigs) | xargs $1 -a \
 		--langdef=kconfig \
 		--language-force=kconfig \
-		--regex-kconfig='/^[[:blank:]]*config[[:blank:]]+([[:alnum:]_]+)/\1/'; \
+		--regex-kconfig='/^[[:blank:]]*(menu|)config[[:blank:]]+([[:alnum:]_]+)/\2/'; \
 	    $(all-defconfigs) | xargs -r $1 -a \
 		--langdef=dotconfig \
 		--language-force=dotconfig \
@@ -1404,7 +1404,7 @@ define xtags
 	elif $1 --version 2>&1 | grep -iq emacs; then \
 	    $(all-sources) | xargs $1 -a; \
 	    $(all-kconfigs) | xargs $1 -a \
-		--regex='/^[ \t]*config[ \t]+\([a-zA-Z0-9_]+\)/\1/'; \
+		--regex='/^[ \t]*(menu|)config[ \t]+\([a-zA-Z0-9_]+\)/\2/'; \
 	    $(all-defconfigs) | xargs -r $1 -a \
 		--regex='/^#?[ \t]?\(CONFIG_[a-zA-Z0-9_]+\)/\1/'; \
 	else \
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
remove-the-macro-get_personality.patch
nv-drop-useless-module-ifdefs.patch
nv-drop-useless-config_pci-checks.patch
nv-fix-sparse-noise.patch
fb-convert-proc-fb-to-seq_file-interface.patch
fb-convert-proc-fb-to-seq_file-interface-checkpatch-fixes.patch
ipmi-remove-write_proc-code.patch
procfs-mem-permission-cleanup.patch
proc-simplify-locking-in-remove_proc_entry.patch
proc-less-special-case-in-xlate-code.patch
proc-drop-several-pde-valid-invalid-checks.patch
proc-remove-proc_bus.patch
proc-remove-proc_root_fs.patch
proc-remove-proc_root_driver.patch
proc-remove-proc_root-from-drivers.patch
proc-convert-proc-tty-ldiscs-to-seq_file-interface.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
nfsd-use-proc_create-to-setup-de-proc_fops.patch
nfs-use-proc_create-to-setup-de-proc_fops.patch
afs-use-non-racy-method-for-proc-entries-creation.patch
ext4-use-non-racy-method-for-proc-entries-creation.patch
reiserfs-use-non-racy-method-for-proc-entries-creation.patch
jbd2-use-non-racy-method-for-proc-entries-creation.patch
sysvipc-use-non-racy-method-for-proc-entries-creation.patch
mm-use-non-racy-method-for-proc-swaps-creation.patch
sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch
zorro-use-non-racy-method-for-proc-entries-creation.patch
samples-use-non-racy-method-for-proc-marker-example-creation.patch
scsi-use-non-racy-method-for-proc-entries-creation.patch
usb-use-non-racy-method-for-proc-entries-creation.patch
s390-use-non-racy-method-for-proc-entries-creation.patch
arm-use-non-racy-method-for-proc-davinci_clocks-creation.patch
avr32-proc-use-non-racy-method-for-proc-tlb-creation.patch
cris-use-non-racy-method-for-proc-system_profile-creation.patch
ia64-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-pcxl_dma-creation.patch
powerpc-use-non-racy-method-for-proc-entries-creation.patch
acpi-use-non-racy-method-for-proc-entries-creation.patch
netdev-use-non-racy-method-for-proc-entries-creation.patch
isdn-use-non-racy-method-for-proc-entries-creation.patch
kernel-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation-2.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

