From: akpm@linux-foundation.org
Subject: [merged] kbuild-fix-kbuildtxt-typos.patch removed from -mm tree
Date: Thu, 15 Jan 2009 11:57:37 -0800
Message-ID: <200901151957.n0FJvbfq007530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753893AbZAOT6W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 14:58:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: fix kbuild.txt typos
has been removed from the -mm tree.  Its filename was
     kbuild-fix-kbuildtxt-typos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: fix kbuild.txt typos
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix typos in the new kbuild.txt file.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kbuild/kbuild.txt |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff -puN Documentation/kbuild/kbuild.txt~kbuild-fix-kbuildtxt-typos Documentation/kbuild/kbuild.txt
--- a/Documentation/kbuild/kbuild.txt~kbuild-fix-kbuildtxt-typos
+++ a/Documentation/kbuild/kbuild.txt
@@ -3,7 +3,7 @@ Environment variables
 KCPPFLAGS
 --------------------------------------------------
 Additional options to pass when preprocessing. The preprocessing options
-will be used in all cases where kbuild do preprocessing including
+will be used in all cases where kbuild does preprocessing including
 building C files and assembler files.
 
 KAFLAGS
@@ -16,7 +16,7 @@ Additional options to the C compiler.
 
 KBUILD_VERBOSE
 --------------------------------------------------
-Set the kbuild verbosity. Can be assinged same values as "V=...".
+Set the kbuild verbosity. Can be assigned same values as "V=...".
 See make help for the full list.
 Setting "V=..." takes precedence over KBUILD_VERBOSE.
 
@@ -35,14 +35,14 @@ KBUILD_OUTPUT
 --------------------------------------------------
 Specify the output directory when building the kernel.
 The output directory can also be specificed using "O=...".
-Setting "O=..." takes precedence over KBUILD_OUTPUT
+Setting "O=..." takes precedence over KBUILD_OUTPUT.
 
 ARCH
 --------------------------------------------------
 Set ARCH to the architecture to be built.
 In most cases the name of the architecture is the same as the
 directory name found in the arch/ directory.
-But some architectures suach as x86 and sparc has aliases.
+But some architectures such as x86 and sparc have aliases.
 x86: i386 for 32 bit, x86_64 for 64 bit
 sparc: sparc for 32 bit, sparc64 for 64 bit
 
@@ -63,7 +63,7 @@ CF is often used on the command-line lik
 INSTALL_PATH
 --------------------------------------------------
 INSTALL_PATH specifies where to place the updated kernel and system map
-images. Default is /boot, but you can set it to other values
+images. Default is /boot, but you can set it to other values.
 
 
 MODLIB
@@ -90,7 +90,7 @@ INSTALL_MOD_STRIP will used as the optio
 
 INSTALL_FW_PATH
 --------------------------------------------------
-INSTALL_FW_PATH specify where to install the firmware blobs.
+INSTALL_FW_PATH specifies where to install the firmware blobs.
 The default value is:
 
     $(INSTALL_MOD_PATH)/lib/firmware
@@ -99,7 +99,7 @@ The value can be overridden in which cas
 
 INSTALL_HDR_PATH
 --------------------------------------------------
-INSTALL_HDR_PATH specify where to install user space headers when
+INSTALL_HDR_PATH specifies where to install user space headers when
 executing "make headers_*".
 The default value is:
 
@@ -112,22 +112,23 @@ The value can be overridden in which cas
 
 KBUILD_MODPOST_WARN
 --------------------------------------------------
-KBUILD_MODPOST_WARN can be set to avoid error out in case of undefined
-symbols in the final module linking stage.
+KBUILD_MODPOST_WARN can be set to avoid errors in case of undefined
+symbols in the final module linking stage. It changes such errors
+into warnings.
 
-KBUILD_MODPOST_FINAL
+KBUILD_MODPOST_NOFINAL
 --------------------------------------------------
 KBUILD_MODPOST_NOFINAL can be set to skip the final link of modules.
-This is solely usefull to speed up test compiles.
+This is solely useful to speed up test compiles.
 
 KBUILD_EXTRA_SYMBOLS
 --------------------------------------------------
-For modules use symbols from another modules.
+For modules that use symbols from other modules.
 See more details in modules.txt.
 
 ALLSOURCE_ARCHS
 --------------------------------------------------
-For tags/TAGS/cscope targets, you can specify more than one archs
-to be included in the databases, separated by blankspace. e.g.
+For tags/TAGS/cscope targets, you can specify more than one arch
+to be included in the databases, separated by blank space. E.g.:
 
     $ make ALLSOURCE_ARCHS="x86 mips arm" tags
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
update-of-documentation-vmtxt-and-proctxt.patch
sysrq-documentation-remove-the-redundant-updated-date.patch
sysrq-documentation-document-why-the-command-header-only-is-shown.patch
sysrq-add-commentary-on-why-we-use-the-console-loglevel-over-using-kern_emerg.patch
jbd-fix-missing-kernel-doc.patch
resources-fix-parameter-name-and-kernel-doc.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
pci-fix-missing-kernel-doc-and-typos.patch
pcih-fix-struct-pci_platform_pm_ops-kernel-doc.patch
esp-fix-section-mismatch-warning.patch
9p-disallow-rdma-if-rdma-cm-isnt-available.patch
max3100-spi-uart-driver.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

