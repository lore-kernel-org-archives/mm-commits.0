From: akpm@linux-foundation.org
Subject: + maintainers-remove-joe-eykholt-from-cisco-fnic-maintainers.patch added to -mm tree
Date: Fri, 27 May 2011 16:42:13 -0700
Message-ID: <201105272342.p4RNgDRI029016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753884Ab1E0Xme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 19:42:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@purestorage.com, James.Bottomley@HansenPartnership.com, abjoglek@cisco.com, buchino@cisco.com, vbhamidi@cisco.com


The patch titled
     MAINTAINERS: remove Joe Eykholt from Cisco fnic maintainers
has been added to the -mm tree.  Its filename is
     maintainers-remove-joe-eykholt-from-cisco-fnic-maintainers.patch

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

origin.patch
maintainers-remove-joe-eykholt-from-cisco-fnic-maintainers.patch

