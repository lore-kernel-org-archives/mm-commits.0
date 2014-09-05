From: akpm@linux-foundation.org
Subject: + checkpatch-remove-unnecessary-after-88.patch added to -mm tree
Date: Fri, 05 Sep 2014 15:56:28 -0700
Message-ID: <540a3f9c.lhJ86K+1HJ42fsBQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaIEW43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2014 18:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: remove unnecessary + after {8,8}
has been added to the -mm tree.  Its filename is
     checkpatch-remove-unnecessary-after-88.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-remove-unnecessary-after-88.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-remove-unnecessary-after-88.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: remove unnecessary + after {8,8}

There's a useless "+" use that needs to be removed as perl 5.20 emits a
"Useless use of greediness modifier '+'" message each time it's hit.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-remove-unnecessary-after-88 scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-remove-unnecessary-after-88
+++ a/scripts/checkpatch.pl
@@ -2431,7 +2431,7 @@ sub process {
 				"please, no space before tabs\n" . $herevet) &&
 			    $fix) {
 				while ($fixed[$fixlinenr] =~
-					   s/(^\+.*) {8,8}+\t/$1\t\t/) {}
+					   s/(^\+.*) {8,8}\t/$1\t\t/) {}
 				while ($fixed[$fixlinenr] =~
 					   s/(^\+.*) +\t/$1\t/) {}
 			}
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-allow-commit-descriptions-on-separate-line-from-commit-id.patch
mm-utilc-add-kstrimdup.patch
checkpatch-fix-spello.patch
checkpatch-remove-debugging-message.patch
checkpatch-update-allowed_asm_includes-macros-add-rebooth-and-timeh.patch
checkpatch-enable-whitespace-checks-for-dts-files.patch
checkpatch-allow-optional-shorter-config-descriptions.patch
checkpatch-allow-optional-shorter-config-descriptions-v4.patch
checkpatch-add-strict-test-for-concatenated-string-elements.patch
checkpatch-remove-unnecessary-after-88.patch
ipc-always-handle-a-new-value-of-auto_msgmni.patch
linux-next.patch
lib-string_helpers-move-documentation-to-c-file.patch
lib-string_helpers-refactoring-the-test-suite.patch
lib-string_helpers-introduce-string_escape_mem.patch
lib-vsprintf-add-%pe-format-specifier.patch
wireless-libertas-print-esaped-string-via-%pe.patch
wireless-ipw2x00-print-ssid-via-%pe.patch
wireless-hostap-proc-print-properly-escaped-ssid.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
lib80211-remove-unused-print_ssid.patch
staging-wlan-ng-use-%pehp-to-print-sn.patch
staging-rtl8192e-use-%pen-to-escape-buffer.patch
staging-rtl8192u-use-%pen-to-escape-buffer.patch

