From: akpm@linux-foundation.org
Subject: [folded-merged]
 checkpatch-add-test-for-blank-lines-after-function-struct-union-enum-declarations.patch removed from -mm tree
Date: Wed, 06 Aug 2014 15:55:42 -0700
Message-ID: <53e2b26e.9qU6w1SI5Tq78ZR4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:37971 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbaHFWzn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:55:43 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so844232pab.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:55:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add test for blank lines after function/struct/union/enum declarations
has been removed from the -mm tree.  Its filename was
     checkpatch-add-test-for-blank-lines-after-function-struct-union-enum-declarations.patch

This patch was dropped because it was folded into checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add test for blank lines after function/struct/union/enum declarations

V2: Fix a problem with patch context lines by checking
    the line after the closing brace is an insertion.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-test-for-blank-lines-after-function-struct-union-enum-declarations scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-test-for-blank-lines-after-function-struct-union-enum-declarations
+++ a/scripts/checkpatch.pl
@@ -2295,6 +2295,7 @@ sub process {
 # check for missing blank lines after struct/union declarations
 # with exceptions for various attributes and macros
 		if ($prevline =~ /^[\+ ]};?\s*$/ &&
+		    $line =~ /^\+/ &&
 		    !($line =~ /^\+\s*$/ ||
 		      $line =~ /^\+\s*EXPORT_SYMBOL/ ||
 		      $line =~ /^\+\s*MODULE_/i ||
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
fs-fscache-make-ctl_table-static.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
slab-convert-last-uses-of-__function__-to-__func__.patch
fs-asus_atk0110-fix-define_simple_attribute-semicolon-definition-and-use.patch
printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch
printk-tweak-do_syslog-to-match-comments.patch
kernelh-remove-deprecated-pack_hex_byte.patch
checkpatch-attempt-to-find-unnecessary-out-of-memory-messages.patch
checkpatch-warn-on-unnecessary-else-after-return-or-break.patch
checkpatch-fix-complex-macro-false-positive-for-escaped-constant-char.patch
checkpatch-fix-function-pointers-in-blank-line-needed-after-declarations-test.patch
checkpatch-ignore-email-headers-better.patch
checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch
checkpatch-add-test-for-blank-lines-after-function-struct-union-enum.patch
checkpatch-add-a-multiple-blank-lines-test.patch
checkpatch-change-blank-line-after-declaration-type-to-line_spacing.patch
checkpatch-quiet-kconfig-help-message-checking.patch
checkpatch-warn-on-unnecessary-parentheses-around-references-of-foo-bar.patch
checkpatch-allow-multiple-const-types.patch
checkpatch-improve-no-space-after-cast-test.patch
checkpatch-emit-fewer-kmalloc_array-kcalloc-conversion-warnings.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
checkpatch-emit-a-warning-on-file-add-move-delete.patch
checkpatch-warn-on-break-after-goto-or-return-with-same-tab-indentation.patch
checkpatch-add-an-index-variable-for-fixed-lines.patch
checkpatch-add-ability-to-insert-and-delete-lines-to-patch-file.patch
checkpatch-add-fix_insert_line-and-fix_delete_line-helpers.patch
checkpatch-use-the-correct-indentation-for-which.patch
checkpatch-add-fix-option-for-a-couple-open_brace-misuses.patch
checkpatch-fix-brace-style-misuses-of-else-and-while.patch
checkpatch-add-for_each-tests-to-indentation-and-brace-tests.patch
checkpatch-add-short-int-to-c-variable-types.patch
checkpatch-add-signed-generic-types.patch
checkpatch-add-test-for-native-c90-types-in-unusual-order.patch
checkpatch-fix-false-positive-missing_break-warnings-with-file.patch
checkpatch-fix-false-positives-for-strict-space-after-cast-test.patch
checkpatch-warn-on-missing-spaces-in-broken-up-quoted.patch
checkpatch-update-declaration_macros-add-uninitialized_var.patch

