From: akpm@linux-foundation.org
Subject: + fix-export_reportpl.patch added to -mm tree
Date: Mon, 27 Aug 2007 14:27:28 -0700
Message-ID: <200708272127.l7RLRSqu028900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58864 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764795AbXH0V2H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 17:28:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     fix export_report.pl
has been added to the -mm tree.  Its filename is
     fix-export_reportpl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix export_report.pl
From: Adrian Bunk <bunk@kernel.org>

This patch fixes an annoying bug of export_report.pl missing the usages
of some exports.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/export_report.pl |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/export_report.pl~fix-export_reportpl scripts/export_report.pl
--- a/scripts/export_report.pl~fix-export_reportpl
+++ a/scripts/export_report.pl
@@ -112,7 +112,7 @@ foreach my $thismod (@allcfiles) {
 			next;
 		}
 		if ($state eq 2) {
-			if ( $_ !~ /0x[0-9a-f]{7,8},/ ) {
+			if ( $_ !~ /0x[0-9a-f]+,/ ) {
 				next;
 			}
 			my $sym = (split /([,"])/,)[4];
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
git-dvb.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
git-nfsd.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
uml-fix-inlines.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
fix-export_reportpl.patch
remove-fs-ext2-balloccreserve_blocks.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
