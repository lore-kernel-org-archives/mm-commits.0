From: akpm@linux-foundation.org
Subject: - make-power-supply-class-available-for-arm-architecture.patch removed from -mm tree
Date: Mon, 15 Oct 2007 19:17:35 -0700
Message-ID: <200710160217.l9G2HZZR004215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35699 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756942AbXJPCRs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 22:17:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike@compulab.co.il, mm-commits@vger.kernel.org


The patch titled
     make power supply class available for arm architecture
has been removed from the -mm tree.  Its filename was
     make-power-supply-class-available-for-arm-architecture.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make power supply class available for arm architecture
From: Mike Rapoport <mike@compulab.co.il>

The config system doesn't show the power supply class menu if arch=arm, this
patch fixes it.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/arm/Kconfig~make-power-supply-class-available-for-arm-architecture arch/arm/Kconfig
--- a/arch/arm/Kconfig~make-power-supply-class-available-for-arm-architecture
+++ a/arch/arm/Kconfig
@@ -1034,6 +1034,8 @@ source "drivers/w1/Kconfig"
 
 source "drivers/hwmon/Kconfig"
 
+source "drivers/power/Kconfig"
+
 #source "drivers/l3/Kconfig"
 
 source "drivers/misc/Kconfig"
_

Patches currently in -mm which might be from mike@compulab.co.il are

origin.patch
