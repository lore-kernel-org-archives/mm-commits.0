From: akpm@linux-foundation.org
Subject: - cris-drivers-cdrom-kconfig-no-longer.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:03:37 -0700
Message-ID: <200708140503.l7E53b9H032075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44090 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765605AbXHNFLL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:11:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris: drivers/cdrom/Kconfig no longer exists
has been removed from the -mm tree.  Its filename was
     cris-drivers-cdrom-kconfig-no-longer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
