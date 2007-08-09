From: akpm@linux-foundation.org
Subject: + cris-drivers-cdrom-kconfig-no-longer.patch added to -mm tree
Date: Thu, 09 Aug 2007 13:34:18 -0700
Message-ID: <200708092034.l79KYIix018186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57953 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755530AbXHIUfO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:35:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, starvik@axis.com


The patch titled
     cris: drivers/cdrom/Kconfig no longer exists
has been added to the -mm tree.  Its filename is
     cris-drivers-cdrom-kconfig-no-longer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cris: drivers/cdrom/Kconfig no longer exists
From: Adrian Bunk <bunk@kernel.org>

scripts/kconfig/conf -d arch/cris/Kconfig
arch/cris/Kconfig:183: can't open file "drivers/cdrom/Kconfig"

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/Kconfig |    2 --
 1 files changed, 2 deletions(-)

diff -puN arch/cris/Kconfig~cris-drivers-cdrom-kconfig-no-longer arch/cris/Kconfig
--- a/arch/cris/Kconfig~cris-drivers-cdrom-kconfig-no-longer
+++ a/arch/cris/Kconfig
@@ -180,8 +180,6 @@ source "drivers/isdn/Kconfig"
 
 source "drivers/telephony/Kconfig"
 
-source "drivers/cdrom/Kconfig"
-
 #
 # input before char - char/joystick depends on it. As does USB.
 #
_

Patches currently in -mm which might be from bunk@kernel.org are

cris-drivers-cdrom-kconfig-no-longer.patch
