From: akpm@osdl.org
Subject: - mbxfb-document-the-new-ioctl.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:13:49 -0800
Message-ID: <200612082013.kB8KDnF9003117@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59793 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946860AbWLHUOf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raph@8d.com, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mbxfb: Document the new ioctl
has been removed from the -mm tree.  Its filename was
     mbxfb-document-the-new-ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mbxfb: Document the new ioctl
From: Raphael Assenat <raph@8d.com>

This patch adds a new ioctl range for the mbxfb driver.

Signed-off-by: Raphael Assenat <raph@8d.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/ioctl-number.txt |    2 ++
 1 file changed, 2 insertions(+)

diff -puN Documentation/ioctl-number.txt~mbxfb-document-the-new-ioctl Documentation/ioctl-number.txt
--- a/Documentation/ioctl-number.txt~mbxfb-document-the-new-ioctl
+++ a/Documentation/ioctl-number.txt
@@ -191,3 +191,5 @@ Code	Seq#	Include File		Comments
 					<mailto:aherrman@de.ibm.com>
 0xF3	00-3F	video/sisfb.h		sisfb (in development)
 					<mailto:thomas@winischhofer.net>
+0xF4	00-1F	video/mbxfb.h		mbxfb
+					<mailto:raph@8d.com>
_

Patches currently in -mm which might be from raph@8d.com are

mbxfb-document-the-new-ioctl.patch

