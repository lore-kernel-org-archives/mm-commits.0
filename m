Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 960EAC433DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 22:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 670FD207D3
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 22:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598307576;
	bh=iZXcncgoinG5Ywg3XUuPP1s0S8cHl3J4blfKOjGLrP0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=2Ll5C+MWUjVH2hF9dh8igfnzyi3tvWujZihBK1+0gONIWVxQOhH4s5myPsc0uqxNM
	 n+Adn56vvVmyrpDtsa4onUK/RX2lMVQdmn3uYX9IS2/0XszqCeva6sJjhhPfuzu1ix
	 IHUjogG8Y5iC9WPEK50ZgRo2dtYbh21MSO+K76T8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgHXWTg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 18:19:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726739AbgHXWTe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 18:19:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC9182078D;
        Mon, 24 Aug 2020 22:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598307574;
        bh=iZXcncgoinG5Ywg3XUuPP1s0S8cHl3J4blfKOjGLrP0=;
        h=Date:From:To:Subject:From;
        b=uo7O5+DV7qZSYBofNY//V8HS9n0Bc22o/WUvWyWT2gzkuvYFkp6yj434Sa3j/FWoB
         RaLp9W5ylLLfi17yrRsfQX8P/yNFejS3yjWt7bY5PYiGT3EEoW92+GCb1MV/WD0+XI
         5WnRwWm5Y4IRbtgtFY97Z3co8oHrVQLdzHWvblGM=
Date:   Mon, 24 Aug 2020 15:19:33 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, bhe@redhat.com, david@redhat.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  +
 doc-vm-fix-typo-in-the-hugetlb-admin-documentation.patch added to -mm tree
Message-ID: <20200824221933.Lox9jBTCS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: doc/vm: fix typo in the hugetlb admin documentation
has been added to the -mm tree.  Its filename is
     doc-vm-fix-typo-in-the-hugetlb-admin-documentation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/doc-vm-fix-typo-in-the-hugetlb-admin-documentation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/doc-vm-fix-typo-in-the-hugetlb-admin-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlbc-make-is_hugetlb_entry_hwpoisoned-return-bool.patch
mm-hugetlbc-remove-the-unnecessary-non_swap_entry.patch
doc-vm-fix-typo-in-the-hugetlb-admin-documentation.patch

