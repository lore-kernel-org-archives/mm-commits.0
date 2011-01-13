From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-stelian-from-the-ams-driver-record.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:06:15 -0800
Message-ID: <201101132008.p0DK8uRX029940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933671Ab1AMUJP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:09:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stelian@popies.net, linux-kernel@hansmi.ch, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: remove Stelian from the AMS driver record
has been removed from the -mm tree.  Its filename was
     maintainers-remove-stelian-from-the-ams-driver-record.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: remove Stelian from the AMS driver record
From: Stelian Pop <stelian@popies.net>

This driver is PPC only, and I am no longer able to test it.

Signed-off-by: Stelian Pop <stelian@popies.net>
Cc: Michael Hanselmann <linux-kernel@hansmi.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-stelian-from-the-ams-driver-record MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-stelian-from-the-ams-driver-record
+++ a/MAINTAINERS
@@ -496,7 +496,6 @@ S:	Supported
 F:	arch/x86/kernel/microcode_amd.c
 
 AMS (Apple Motion Sensor) DRIVER
-M:	Stelian Pop <stelian@popies.net>
 M:	Michael Hanselmann <linux-kernel@hansmi.ch>
 S:	Supported
 F:	drivers/macintosh/ams/
_

Patches currently in -mm which might be from stelian@popies.net are

origin.patch

