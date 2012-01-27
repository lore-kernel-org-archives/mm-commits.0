From: akpm@linux-foundation.org
Subject: + thermal_sys-remove-unnecessary-line-continuations.patch added to -mm tree
Date: Thu, 26 Jan 2012 16:55:00 -0800
Message-ID: <20120127005501.79DC3A049C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:43795 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab2A0AzE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2012 19:55:04 -0500
Received: by wibhm11 with SMTP id hm11so79228wib.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2012 16:55:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, jj@chaosbits.net, lenb@kernel.org


The patch titled
     Subject: thermal_sys: remove unnecessary line continuations
has been added to the -mm tree.  Its filename is
     thermal_sys-remove-unnecessary-line-continuations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: thermal_sys: remove unnecessary line continuations

Line continations are not necessary in function calls or statements. 
Remove them.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_sys.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/thermal/thermal_sys.c~thermal_sys-remove-unnecessary-line-continuations drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal_sys-remove-unnecessary-line-continuations
+++ a/drivers/thermal/thermal_sys.c
@@ -281,8 +281,7 @@ passive_show(struct device *dev, struct 
 static DEVICE_ATTR(type, 0444, type_show, NULL);
 static DEVICE_ATTR(temp, 0444, temp_show, NULL);
 static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
-static DEVICE_ATTR(passive, S_IRUGO | S_IWUSR, passive_show, \
-		   passive_store);
+static DEVICE_ATTR(passive, S_IRUGO | S_IWUSR, passive_show, passive_store);
 
 static struct device_attribute trip_point_attrs[] = {
 	__ATTR(trip_point_0_type, 0444, trip_point_type_show, NULL),
@@ -1313,8 +1312,8 @@ int thermal_generate_netlink_event(u32 o
 	static unsigned int thermal_event_seqnum;
 
 	/* allocate memory */
-	size = nla_total_size(sizeof(struct thermal_genl_event)) + \
-				nla_total_size(0);
+	size = nla_total_size(sizeof(struct thermal_genl_event)) +
+	       nla_total_size(0);
 
 	skb = genlmsg_new(size, GFP_ATOMIC);
 	if (!skb)
@@ -1330,8 +1329,8 @@ int thermal_generate_netlink_event(u32 o
 	}
 
 	/* fill the data */
-	attr = nla_reserve(skb, THERMAL_GENL_ATTR_EVENT, \
-			sizeof(struct thermal_genl_event));
+	attr = nla_reserve(skb, THERMAL_GENL_ATTR_EVENT,
+			   sizeof(struct thermal_genl_event));
 
 	if (!attr) {
 		nlmsg_free(skb);
_
Subject: Subject: thermal_sys: remove unnecessary line continuations

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-update-partitions-block-f-patterns.patch
maintainers-remove-imx5-section.patch
maintainers-remove-staging-sections.patch
maintainers-update-lguest-f-patterns.patch
linux-next.patch
thermal_sys-remove-unnecessary-line-continuations.patch
thermal_sys-remove-obfuscating-used-once-macros.patch
thermal_sys-kernel-style-cleanups.patch
thermal_sys-convert-printks-to-pr_level.patch
maintainers-staging-cx25821-add-l-linux-media.patch
maintainers-fix-remoteproc-f-typo.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch

