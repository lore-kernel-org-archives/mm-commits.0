From: akpm@linux-foundation.org
Subject: [merged] documentation-update-kernel-doc-nano-howto-information.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:19:08 -0800
Message-ID: <201001112019.o0BKJ81h025540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754066Ab0AKUUF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:20:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     documentation: update kernel-doc-nano-HOWTO information
has been removed from the -mm tree.  Its filename was
     documentation-update-kernel-doc-nano-howto-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: documentation: update kernel-doc-nano-HOWTO information
From: Randy Dunlap <randy.dunlap@oracle.com>

Remove comments about function short descriptions not allowed to be on
multiple lines (that was fixed/changed recently).

Add comments that function "section header:" names need to be unique per
function/struct/union/typedef/enum.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-doc-nano-HOWTO.txt |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN Documentation/kernel-doc-nano-HOWTO.txt~documentation-update-kernel-doc-nano-howto-information Documentation/kernel-doc-nano-HOWTO.txt
--- a/Documentation/kernel-doc-nano-HOWTO.txt~documentation-update-kernel-doc-nano-howto-information
+++ a/Documentation/kernel-doc-nano-HOWTO.txt
@@ -214,11 +214,13 @@ The format of the block comment is like 
  * (section header: (section description)? )*
 (*)?*/
 
-The short function description ***cannot be multiline***, but the other
-descriptions can be (and they can contain blank lines).  If you continue
-that initial short description onto a second line, that second line will
-appear further down at the beginning of the description section, which is
-almost certainly not what you had in mind.
+All "description" text can span multiple lines, although the
+function_name & its short description are traditionally on a single line.
+Description text may also contain blank lines (i.e., lines that contain
+only a "*").
+
+"section header:" names must be unique per function (or struct,
+union, typedef, enum).
 
 Avoid putting a spurious blank line after the function name, or else the
 description will be repeated!
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
mfgpt-move-clocksource-menu.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

