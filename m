From: akpm@linux-foundation.org
Subject: [folded-merged]
 checkpatch-match-more-world-writable-permissions-fix.patch removed from -mm tree
Date: Thu, 16 Apr 2015 12:00:45 -0700
Message-ID: <553006dd.b/yjGY8lVVEA1f9y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbbDPTAq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 15:00:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-match-more-world-writable-permissions-fix
has been removed from the -mm tree.  Its filename was
     checkpatch-match-more-world-writable-permissions-fix.patch

This patch was dropped because it was folded into checkpatch-match-more-world-writable-permissions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: checkpatch-match-more-world-writable-permissions-fix

remove stray $

Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-match-more-world-writable-permissions-fix scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-match-more-world-writable-permissions-fix
+++ a/scripts/checkpatch.pl
@@ -443,7 +443,7 @@ foreach my $entry (@mode_permission_func
 	$mode_perms_search .= $entry->[0];
 }
 
-$our $mode_perms_world_writable = qr{
+our $mode_perms_world_writable = qr{
 	S_IWUGO		|
 	S_IWOTH		|
 	S_IRWXUGO	|
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-find__bit-reimplementation.patch
checkpatch-match-more-world-writable-permissions.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kernel-forkc-avoid-division-by-zero-fix.patch
kernel-forkc-avoid-division-by-zero-fix-fix.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
mm-rcu-protected-get_mm_exe_file.patch
affs-kstrdup-memory-handling-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch

