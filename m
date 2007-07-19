From: akpm@linux-foundation.org
Subject: + hpettxt-broken-link-fix.patch added to -mm tree
Date: Thu, 19 Jul 2007 16:56:35 -0700
Message-ID: <200707192356.l6JNuZHR029494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39762 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761866AbXGSX5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 19:57:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com


The patch titled
     hpet.txt: broken link fix
has been added to the -mm tree.  Its filename is
     hpettxt-broken-link-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hpet.txt: broken link fix
From: Dave Young <hidave.darkstar@gmail.com>

The specification link in hpet document is broken.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hpet.txt |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/hpet.txt~hpettxt-broken-link-fix Documentation/hpet.txt
--- a/Documentation/hpet.txt~hpettxt-broken-link-fix
+++ a/Documentation/hpet.txt
@@ -5,7 +5,7 @@ for the 8254 and Real Time Clock (RTC) p
 Each HPET can have up to 32 timers.  It is possible to configure the
 first two timers as legacy replacements for 8254 and RTC periodic timers.
 A specification done by Intel and Microsoft can be found at
-<http://www.intel.com/hardwaredesign/hpetspec.htm>.
+<http://www.intel.com/technology/architecture/hpetspec.htm>.
 
 The driver supports detection of HPET driver allocation and initialization
 of the HPET before the driver module_init routine is called.  This enables
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
zisofs-use-mutex-instead-of-semaphore.patch
hpettxt-broken-link-fix.patch
