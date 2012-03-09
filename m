From: akpm@linux-foundation.org
Subject: + checkpatch-whitespace-add-remove-blank-lines.patch added to -mm tree
Date: Thu, 08 Mar 2012 16:33:26 -0800
Message-ID: <20120309003326.E44E8A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:56491 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759298Ab2CIAd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 19:33:29 -0500
Received: by wgbdt11 with SMTP id dt11so36977wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 16:33:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com


The patch titled
     Subject: checkpatch: whitespace - add/remove blank lines
has been added to the -mm tree.  Its filename is
     checkpatch-whitespace-add-remove-blank-lines.patch

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
Subject: checkpatch: whitespace - add/remove blank lines

Add blank lines between a few tests, remove an extraneous one.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-whitespace-add-remove-blank-lines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-whitespace-add-remove-blank-lines
+++ a/scripts/checkpatch.pl
@@ -3354,18 +3354,20 @@ sub process {
 		if ($line =~ /^.\s*sema_init.+,\W?0\W?\)/) {
 			WARN("CONSIDER_COMPLETION",
 			     "consider using a completion\n" . $herecurr);
-
 		}
+
 # recommend kstrto* over simple_strto* and strict_strto*
 		if ($line =~ /\b((simple|strict)_(strto(l|ll|ul|ull)))\s*\(/) {
 			WARN("CONSIDER_KSTRTO",
 			     "$1 is obsolete, use k$3 instead\n" . $herecurr);
 		}
+
 # check for __initcall(), use device_initcall() explicitly please
 		if ($line =~ /^.\s*__initcall\s*\(/) {
 			WARN("USE_DEVICE_INITCALL",
 			     "please use device_initcall() instead of __initcall()\n" . $herecurr);
 		}
+
 # check for various ops structs, ensure they are const.
 		my $struct_ops = qr{acpi_dock_ops|
 				address_space_operations|
_
Subject: Subject: checkpatch: whitespace - add/remove blank lines

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
thermal_sys-remove-unnecessary-line-continuations.patch
thermal_sys-remove-obfuscating-used-once-macros.patch
thermal_sys-kernel-style-cleanups.patch
thermal_sys-convert-printks-to-pr_level.patch
get_maintainer-use-a-default-unknown-s-status-role.patch
maintainers-fix-remoteproc-f-typo.patch
maintainers-update-mca-section.patch
maintainers-update-git-urls-for-26-deletions.patch
maintainers-add-status-to-alpha-architecture.patch
maintainers-add-s-maintained-to-clkdev-and-clk-sections.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch
checkpatch-add-some-strict-coding-style-checks.patch
checkpatch-add-some-strict-coding-style-checks-v3.patch
checkpatchpl-be-silent-when-q-and-ignore-is-given.patch
checkpatch-catch-usage-when-not-at-the-beginning-of-defination.patch
checkpatch-allow-simple-character-constants-in-defines.patch
checkpatch-handle-string-concatenation-in-simple-defines.patch
checkpatch-high-precidence-operators-do-not-require-additional-parentheses-in-defines.patch
checkpatch-add-to-type-extensions.patch
checkpatch-add-strict-tests-for-braces-comments-and-casts.patch
checkpatch-add-strict-test-for-strings-split-across-multiple-lines.patch
checkpatch-warn-on-use-of-yield.patch
checkpatch-whitespace-add-remove-blank-lines.patch

