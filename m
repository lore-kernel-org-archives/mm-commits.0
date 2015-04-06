From: akpm@linux-foundation.org
Subject: + checkpatch-add-uart_ops-to-normally-const-structs.patch added
 to -mm tree
Date: Mon, 06 Apr 2015 12:52:53 -0700
Message-ID: <5522e415.YVkDkwsxpXEtovFZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbbDFTwy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2015 15:52:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@shadowen.org, gregkh@linuxfoundation.org, jslaby@suse.cz, mcoquelin.stm32@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add uart_ops to normally const structs
has been added to the -mm tree.  Its filename is
     checkpatch-add-uart_ops-to-normally-const-structs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-uart_ops-to-normally-const-structs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-uart_ops-to-normally-const-structs.patch

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
Subject: checkpatch: add uart_ops to normally const structs

Add another struct to the list of normally const struct types

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-uart_ops-to-normally-const-structs scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-uart_ops-to-normally-const-structs
+++ a/scripts/checkpatch.pl
@@ -5339,6 +5339,7 @@ sub process {
 				stacktrace_ops|
 				sysfs_ops|
 				tty_operations|
+				uart_ops|
 				usb_mon_operations|
 				wd_ops}x;
 		if ($line !~ /\bconst\b/ &&
_

Patches currently in -mm which might be from joe@perches.com are

ocfs2-logging-remove-static-buffer-use-vsprintf-extension-%pv.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
slub-use-bool-function-return-values-of-true-false-not-1-0.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch
maintainers-use-tabs-consistently.patch
maintainers-credits-remove-stefano-brivio-from-b43.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value-fix.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
cris-fasttimer-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
checkpatch-add-test-for-repeated-const-uses.patch
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch
checkpatch-add-define-foo-string-long-line-exception.patch
checkpatch-add-uart_ops-to-normally-const-structs.patch
adfs-returning-correct-return-values.patch
linux-next.patch

