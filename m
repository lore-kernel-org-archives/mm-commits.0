From: akpm@linux-foundation.org
Subject: + maintainers-add-drivers-platform-msm-to-msm-subsystem.patch added to -mm tree
Date: Wed, 09 Mar 2011 15:23:21 -0800
Message-ID: <201103092323.p29NNLDx001731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062Ab1CIXXn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2011 18:23:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kheitke@codeaurora.org


The patch titled
     MAINTAINERS: add drivers/platform/msm to MSM subsystem
has been added to the -mm tree.  Its filename is
     maintainers-add-drivers-platform-msm-to-msm-subsystem.patch

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
Subject: MAINTAINERS: add drivers/platform/msm to MSM subsystem
From: Kenneth Heitke <kheitke@codeaurora.org>

Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-drivers-platform-msm-to-msm-subsystem MAINTAINERS
--- a/MAINTAINERS~maintainers-add-drivers-platform-msm-to-msm-subsystem
+++ a/MAINTAINERS
@@ -912,6 +912,7 @@ F:	drivers/mmc/host/msm_sdcc.c
 F:	drivers/mmc/host/msm_sdcc.h
 F:	drivers/tty/serial/msm_serial.h
 F:	drivers/tty/serial/msm_serial.c
+F:	drivers/platform/msm/
 T:	git git://codeaurora.org/quic/kernel/davidb/linux-msm.git
 S:	Maintained
 
_

Patches currently in -mm which might be from kheitke@codeaurora.org are

maintainers-add-drivers-platform-msm-to-msm-subsystem.patch

