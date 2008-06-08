From: akpm@linux-foundation.org
Subject: - fujitsu-laptop-autoload-module-on-lifebook-p1510d.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:47:33 -0700
Message-ID: <200806081947.m58JlXf4017427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753960AbYFHTsD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:48:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcbw@redhat.com, greg@kroah.com, jwoithe@physics.adelaide.edu.au, len.brown@intel.com, mm-commits@vger.kernel.org


The patch titled
     fujitsu-laptop: autoload module on Lifebook P1510D
has been removed from the -mm tree.  Its filename was
     fujitsu-laptop-autoload-module-on-lifebook-p1510d.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fujitsu-laptop: autoload module on Lifebook P1510D
From: Dan Williams <dcbw@redhat.com>

Signed-off-by: Dan Williams <dcbw@redhat.com>
Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: Len Brown <len.brown@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/fujitsu-laptop.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/misc/fujitsu-laptop.c~fujitsu-laptop-autoload-module-on-lifebook-p1510d drivers/misc/fujitsu-laptop.c
--- a/drivers/misc/fujitsu-laptop.c~fujitsu-laptop-autoload-module-on-lifebook-p1510d
+++ a/drivers/misc/fujitsu-laptop.c
@@ -352,3 +352,9 @@ MODULE_AUTHOR("Jonathan Woithe");
 MODULE_DESCRIPTION("Fujitsu laptop extras support");
 MODULE_VERSION(FUJITSU_DRIVER_VERSION);
 MODULE_LICENSE("GPL");
+
+static struct pnp_device_id pnp_ids[] = {
+	{ .id = "FUJ02bf" },
+	{ .id = "" }
+};
+MODULE_DEVICE_TABLE(pnp, pnp_ids);
_

Patches currently in -mm which might be from dcbw@redhat.com are

origin.patch
linux-next.patch
airo-use-simple_read_from_buffer.patch

