Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CDDC433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D06F8221FF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709394;
	bh=kAijEPfZjHqp5SfdS6kwY3SyAmPUmKnaVdTSY2hk9ws=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=bU2mvl2QQbWi39dz8jBrq7JlxiiUY1G3B7CYsIehFyFkcvr+sWksaqv62B+NRM7wf
	 GlOinrIYYOcTYd44VAagahqempqN5CmJrL0yGs1qRFoUbKLUAXZS+wiB9Ulh5wxwOj
	 SrKOboh7usByAmXG7QANSwCvIcxtlm3WRGMyN6g0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388352AbgJNVDO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:03:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387703AbgJNVDO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:03:14 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2649206B2;
        Wed, 14 Oct 2020 21:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709393;
        bh=kAijEPfZjHqp5SfdS6kwY3SyAmPUmKnaVdTSY2hk9ws=;
        h=Date:From:To:Subject:From;
        b=a0LnVOS0RlALD/4Y2EhmkfiVD841oh97hHNHvNHHauRO7aWVbu5n86Gkc4Kq5KrZ1
         YJXceK5ZkI2XYcw5M9cd4VURvKVQwJW6IvEjGcwamJcgPfvcYEm2iyseVkgFl3y4d4
         qSpsSB3nY0zpev0WmlasXS8xn4EiKrtv3E64xY0w=
Date:   Wed, 14 Oct 2020 14:03:13 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, bhe@redhat.com, david@redhat.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  [merged]
 doc-vm-fix-typo-in-the-hugetlb-admin-documentation.patch removed from -mm
 tree
Message-ID: <20201014210313.hpMjXTgWl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: doc/vm: fix typo in the hugetlb admin documentation
has been removed from the -mm tree.  Its filename was
     doc-vm-fix-typo-in-the-hugetlb-admin-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: doc/vm: fix typo in the hugetlb admin documentation

Change 'pecify' to 'Specify'.

Link: https://lkml.kernel.org/r/20200723032248.24772-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/hugetlbpage.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/hugetlbpage.rst~doc-vm-fix-typo-in-the-hugetlb-admin-documentation
+++ a/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -131,7 +131,7 @@ hugepages
 	parameter is preceded by an invalid hugepagesz parameter, it will
 	be ignored.
 default_hugepagesz
-	pecify the default huge page size.  This parameter can
+	Specify the default huge page size.  This parameter can
 	only be specified once on the command line.  default_hugepagesz can
 	optionally be followed by the hugepages parameter to preallocate a
 	specific number of huge pages of default size.  The number of default
_

Patches currently in -mm which might be from bhe@redhat.com are


