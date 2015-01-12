From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-rydbergs-addresses.patch removed from -mm tree
Date: Mon, 12 Jan 2015 11:33:18 -0800
Message-ID: <54b4217e.XYwxI97RnO/FJZKr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbbALTdS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 14:33:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@bitmath.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update rydberg's addresses
has been removed from the -mm tree.  Its filename was
     maintainers-update-rydbergs-addresses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Henrik Rydberg <rydberg@bitmath.org>
Subject: MAINTAINERS: update rydberg's addresses

My ISP finally gave up on the old mail address, so I am moving things over
to bitmath.org instead.  Also change the status fields to better reflect
reality.

Signed-off-by: Henrik Rydberg <rydberg@bitmath.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |   12 ++++++------
 2 files changed, 7 insertions(+), 6 deletions(-)

diff -puN .mailmap~maintainers-update-rydbergs-addresses .mailmap
--- a/.mailmap~maintainers-update-rydbergs-addresses
+++ a/.mailmap
@@ -51,6 +51,7 @@ Greg Kroah-Hartman <gregkh@suse.de>
 Greg Kroah-Hartman <greg@kroah.com>
 Henk Vergonet <Henk.Vergonet@gmail.com>
 Henrik Kretzschmar <henne@nachtwindheim.de>
+Henrik Rydberg <rydberg@bitmath.org>
 Herbert Xu <herbert@gondor.apana.org.au>
 Jacob Shin <Jacob.Shin@amd.com>
 James Bottomley <jejb@mulgrave.(none)>
diff -puN MAINTAINERS~maintainers-update-rydbergs-addresses MAINTAINERS
--- a/MAINTAINERS~maintainers-update-rydbergs-addresses
+++ a/MAINTAINERS
@@ -724,15 +724,15 @@ F:	include/uapi/linux/apm_bios.h
 F:	drivers/char/apm-emulation.c
 
 APPLE BCM5974 MULTITOUCH DRIVER
-M:	Henrik Rydberg <rydberg@euromail.se>
+M:	Henrik Rydberg <rydberg@bitmath.org>
 L:	linux-input@vger.kernel.org
-S:	Maintained
+S:	Odd fixes
 F:	drivers/input/mouse/bcm5974.c
 
 APPLE SMC DRIVER
-M:	Henrik Rydberg <rydberg@euromail.se>
+M:	Henrik Rydberg <rydberg@bitmath.org>
 L:	lm-sensors@lm-sensors.org
-S:	Maintained
+S:	Odd fixes
 F:	drivers/hwmon/applesmc.c
 
 APPLETALK NETWORK LAYER
@@ -4940,10 +4940,10 @@ F:	include/uapi/linux/input.h
 F:	include/linux/input/
 
 INPUT MULTITOUCH (MT) PROTOCOL
-M:	Henrik Rydberg <rydberg@euromail.se>
+M:	Henrik Rydberg <rydberg@bitmath.org>
 L:	linux-input@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rydberg/input-mt.git
-S:	Maintained
+S:	Odd fixes
 F:	Documentation/input/multi-touch-protocol.txt
 F:	drivers/input/input-mt.c
 K:	\b(ABS|SYN)_MT_
_

Patches currently in -mm which might be from rydberg@bitmath.org are


