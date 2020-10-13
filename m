Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DF0DC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBB2F2222F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633378;
	bh=vufI4ew+yoZIuQwmMUnL+ErkmZOVqL/XR7Um6YVah54=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=pK3liRsHg9Bq5sVDopcW7sXpfau1r8uvxpih2z8qd2ayf44AqFRAkNfxS+/KDKqTL
	 mDmVCj0tbwHOoe4MARbW5CHoCkXDXJ4BteUwWJajSZHX9zx8Y6aprvdgfxcd1aqaCa
	 E7MQkJD44vEeVqrRx/JehVfqVWT4IJi2DcDrQVi4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388662AbgJMX4S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMX4S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:56:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C10AA2222E;
        Tue, 13 Oct 2020 23:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633378;
        bh=vufI4ew+yoZIuQwmMUnL+ErkmZOVqL/XR7Um6YVah54=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=z0Ys0wpNvqokQuy442mEYuOPhUVsdmwJhzUpGMtwsNHCDtrh7qoy4QnsAbGfnpBPw
         +07Mu8/aZ2dcDb1HRWSHjK3s6OsR7uyld67NC1QR8duS3V9Nh+6UJWuW1Dvawx1D4S
         EuZEEdF/fSImrcwRqVfk3XAOmfsPZPMhZEa+l5Vw=
Date:   Tue, 13 Oct 2020 16:56:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        bhe@redhat.com, david@redhat.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 143/181] doc/vm: fix typo in the hugetlb admin
 documentation
Message-ID: <20201013235617.60GgIvWj9%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
