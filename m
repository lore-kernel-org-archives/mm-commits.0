Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61878C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EF3220774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266182;
	bh=8/0dtpbkWnjn9l9xULVf/RmnUwFIKWAfRXvl0Qudhsk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=u8mfUEWJ1N/y6cQm2cjaMvH0eS7WaBIPf2iip8caWmfTr638Z/h2OvmvGRf2rzFpH
	 oIcGnt1893TZMkjMix7jTy+emy0Ha599uzBedGGbJ0XECYHGcuYeNJAPWrDfJ3sC/s
	 mjlfM0FinVUgl9cdNNplr0zWJUJIv7TBuixapnjU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgHLVDB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgHLVDB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:01 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7389120774;
        Wed, 12 Aug 2020 21:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266179;
        bh=8/0dtpbkWnjn9l9xULVf/RmnUwFIKWAfRXvl0Qudhsk=;
        h=Date:From:To:Subject:From;
        b=JKBeeJ7cXOzxnxfP4o7ONCMk9pht3uhYFix9+41lzGn5XAPfE5GAteOUWaRHIJFbr
         MylPGS4vkfn7KGPIfqtMSmZRZue20cEdeWnwhWImr+GaV7hVA2TgQ0/b/AnSE1NhPE
         H+es/yoWn6mx+hmQvBflzNgOqLm08KvXws5at5EM=
Date:   Wed, 12 Aug 2020 14:02:59 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, ziy@nvidia.com
Subject:  [merged] mm-migratec-delete-duplicated-word.patch removed
 from -mm tree
Message-ID: <20200812210259.pQvqQ3GwC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: delete duplicated word
has been removed from the -mm tree.  Its filename was
     mm-migratec-delete-duplicated-word.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/migrate.c: delete duplicated word

Drop the repeated word "and".

Link: http://lkml.kernel.org/r/20200801173822.14973-8-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migratec-delete-duplicated-word
+++ a/mm/migrate.c
@@ -2667,7 +2667,7 @@ restore:
 
 /**
  * migrate_vma_setup() - prepare to migrate a range of memory
- * @args: contains the vma, start, and and pfns arrays for the migration
+ * @args: contains the vma, start, and pfns arrays for the migration
  *
  * Returns: negative errno on failures, 0 when 0 or more pages were migrated
  * without an error.
_

Patches currently in -mm which might be from rdunlap@infradead.org are


