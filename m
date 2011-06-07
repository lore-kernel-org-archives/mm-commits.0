From: akpm@linux-foundation.org
Subject: [to-be-updated] maintainers-remove-joe-eykholt-from-cisco-fnic-maintainers.patch removed from -mm tree
Date: Tue, 07 Jun 2011 14:51:56 -0700
Message-ID: <201106072151.p57Lpu1v029240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469Ab1FGVwp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2011 17:52:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@purestorage.com, James.Bottomley@HansenPartnership.com, abjoglek@cisco.com, buchino@cisco.com, vbhamidi@cisco.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: remove Joe Eykholt from Cisco fnic maintainers
has been removed from the -mm tree.  Its filename was
     maintainers-remove-joe-eykholt-from-cisco-fnic-maintainers.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: remove Joe Eykholt from Cisco fnic maintainers
From: Roland Dreier <roland@purestorage.com>

Joe is no longer working at Cisco and his @cisco.com email bounces. 
Presumably he is no longer maintaining fnic either.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Cc: Abhijeet Joglekar <abjoglek@cisco.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Venkata Siva Vijayendra Bhamidipati <vbhamidi@cisco.com>
Cc: Brian Uchino <buchino@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-joe-eykholt-from-cisco-fnic-maintainers MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-joe-eykholt-from-cisco-fnic-maintainers
+++ a/MAINTAINERS
@@ -1766,7 +1766,6 @@ F:	include/linux/clk.h
 
 CISCO FCOE HBA DRIVER
 M:	Abhijeet Joglekar <abjoglek@cisco.com>
-M:	Joe Eykholt <jeykholt@cisco.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/fnic/
_

Patches currently in -mm which might be from roland@purestorage.com are


