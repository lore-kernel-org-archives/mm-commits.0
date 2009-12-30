From: akpm@linux-foundation.org
Subject: + documentation-update-kernel-doc-nano-howto-information.patch added to -mm tree
Date: Wed, 30 Dec 2009 15:20:16 -0800
Message-ID: <200912302320.nBUNKG2P007901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752106AbZL3XUv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Dec 2009 18:20:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     documentation: update kernel-doc-nano-HOWTO information
has been added to the -mm tree.  Its filename is
     documentation-update-kernel-doc-nano-howto-information.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

docs-large-update-to-ioctl-numbertxt.patch
linux-next.patch
documentation-update-ring-buffer-designtxt.patch
documentation-update-kernel-doc-nano-howto-information.patch
mfgpt-move-clocksource-menu.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

