From: akpm@linux-foundation.org
Subject: [to-be-updated] drivers-edac-edac_mc_sysfsc-check-the-kzalloc-return-value.patch removed from -mm tree
Date: Tue, 23 Oct 2012 13:37:28 -0700
Message-ID: <20121023203728.D7A011E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:39477 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784Ab2JWUha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 16:37:30 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so534601vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 13:37:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirjanov@gmail.com, borislav.petkov@amd.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/edac/edac_mc_sysfs.c: check the kzalloc return value
has been removed from the -mm tree.  Its filename was
     drivers-edac-edac_mc_sysfsc-check-the-kzalloc-return-value.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Denis Kirjanov <kirjanov@gmail.com>
Subject: drivers/edac/edac_mc_sysfs.c: check the kzalloc return value

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_mc_sysfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/edac/edac_mc_sysfs.c~drivers-edac-edac_mc_sysfsc-check-the-kzalloc-return-value drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~drivers-edac-edac_mc_sysfsc-check-the-kzalloc-return-value
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -1136,7 +1136,8 @@ int __init edac_mc_sysfs_init(void)
 	}
 
 	mci_pdev = kzalloc(sizeof(*mci_pdev), GFP_KERNEL);
