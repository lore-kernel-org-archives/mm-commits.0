From: akpm@linux-foundation.org
Subject: + make-power-supply-class-available-for-arm-architecture.patch added to -mm tree
Date: Thu, 09 Aug 2007 13:50:05 -0700
Message-ID: <200708092050.l79Ko5Dh018804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55226 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755838AbXHIUuQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:50:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike@compulab.co.il


The patch titled
     make power supply class available for arm architecture
has been added to the -mm tree.  Its filename is
     make-power-supply-class-available-for-arm-architecture.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make power supply class available for arm architecture
From: Mike Rapoport <mike@compulab.co.il>

The config system doesn't show the power supply class menu if arch=arm, this
patch fixes it.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig |    2 ++
 1 files changed, 2 insertions(+)

diff -puN arch/arm/Kconfig~make-power-supply-class-available-for-arm-architecture arch/arm/Kconfig
--- a/arch/arm/Kconfig~make-power-supply-class-available-for-arm-architecture
+++ a/arch/arm/Kconfig
@@ -1028,6 +1028,8 @@ source "drivers/w1/Kconfig"
 
 source "drivers/hwmon/Kconfig"
 
+source "drivers/power/Kconfig"
+
 #source "drivers/l3/Kconfig"
 
 source "drivers/misc/Kconfig"
_

Patches currently in -mm which might be from mike@compulab.co.il are

make-power-supply-class-available-for-arm-architecture.patch
