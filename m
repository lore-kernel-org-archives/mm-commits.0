From: akpm@linux-foundation.org
Subject: - security-convert-lsm-into-a-static-interface-fix-2-fix.patch removed from -mm tree
Date: Tue, 16 Oct 2007 18:33:16 -0700
Message-ID: <200710170133.l9H1XGNr027764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754018AbXJQBfG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 21:35:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, arjan@infradead.org, chrisw@sous-sol.org, jmorris@namei.org, sds@tycho.nsa.gov, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fix LSM kernel-doc
has been removed from the -mm tree.  Its filename was
     security-convert-lsm-into-a-static-interface-fix-2-fix.patch

This patch was dropped because it was folded into security-convert-lsm-into-a-static-interface.patch

------------------------------------------------------
Subject: fix LSM kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

I'd like mainline (Linus's git) to be kernel-doc clean (it's not, but all of
the patches for it have been sent, just getting them merged is the challenge).
 One way to address this for future merges is to fix -mm kernel-doc.

The security-convert-to-static patches need this docbook change.

Warning(linux-2.6.23-rc1-mm1//security/security.c): no structured comments found

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~security-convert-lsm-into-a-static-interface-fix-2-fix Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~security-convert-lsm-into-a-static-interface-fix-2-fix
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -340,7 +340,7 @@ X!Earch/i386/kernel/mca.c
 
   <chapter id="security">
      <title>Security Framework</title>
-!Esecurity/security.c
+!Isecurity/security.c
   </chapter>
 
   <chapter id="audit">
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
docs-ramdisk-initrd-initramfs-corrections.patch
quota-send-messages-via-netlink.patch
maintainers-linux-omap-list-is-subscribers-only.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
doc-about-email-clients-for-linux-patches.patch
change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2.patch
dont-truncate-proc-pid-environ-at-4096-characters.patch
dontdiff-update-based-on-gitignore-updates.patch
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
remap_file_pages-kernel-doc-corrections.patch
security-convert-lsm-into-a-static-interface.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
git-acpi.patch
git-alsa.patch
fix-auditscc-kernel-doc.patch
comment-typo-in-scripts-kconfig-makefile.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
add-samples-subdir.patch
profile-likely-unlikely-macros.patch
