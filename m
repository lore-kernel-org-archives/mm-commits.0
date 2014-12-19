From: akpm@linux-foundation.org
Subject: + maintainers-update-rydbergs-addresses.patch added to -mm tree
Date: Fri, 19 Dec 2014 14:14:32 -0800
Message-ID: <5494a348.AG43J99AFv4pF75P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaLSWOd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 17:14:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rydberg@bitmath.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update rydberg's addresses
has been added to the -mm tree.  Its filename is
     maintainers-update-rydbergs-addresses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-rydbergs-addresses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-rydbergs-addresses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Henrik Rydberg <rydberg@bitmath.org>
Subject: MAINTAINERS: update rydberg's addresses

My ISP finally gave up on the old mail address, so I am moving things over
to bitmath.org instead.  Also change the status fields to better reflect
reality.

Signed-off-by: Henrik Rydberg <rydberg@bitmath.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

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
@@ -4939,10 +4939,10 @@ F:	include/uapi/linux/input.h
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

maintainers-update-rydbergs-addresses.patch

