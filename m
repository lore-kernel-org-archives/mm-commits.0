Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F1DC433ED
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FE4361448
	for <mm-commits@archiver.kernel.org>; Mon, 10 May 2021 04:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbhEJEWc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 00:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhEJEWc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 00:22:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3903C61437;
        Mon, 10 May 2021 04:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620620488;
        bh=Y91yxdmMt0zEW0QNztyIw7uvAmDY9w72srw1JwAkfZY=;
        h=Date:From:To:Subject:From;
        b=sMRDDHEZFgqtZiBhs2/q8HOZei4k86hthPN52boNCf7uv5XITU/fVT9f4Bs3Md3SB
         wFMuGj69AF6xwJxz9qA4FUecSvON/aSmFXtaB5i3v+6+YRLanfsgrQzsneSqXuz6bs
         JxNPa0FpTAY4eUsNll4VsqyH2bKHLAFlg8I0RRVg=
Date:   Sun, 09 May 2021 21:21:26 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, arnd@arndb.de, chris@zankel.net,
        dave.hansen@intel.com, david@redhat.com, deller@gmx.de,
        eike-kernel@sf-tec.de, hughd@google.com, ink@jurassic.park.msu.ru,
        James.Bottomley@HansenPartnership.com, jannh@google.com,
        jcmvbkbc@gmail.com, jgg@ziepe.ca, kirill.shutemov@linux.intel.com,
        linuxram@us.ibm.com, mattst88@gmail.com, mhocko@suse.com,
        mike.kravetz@oracle.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        peterx@redhat.com, riel@surriel.com, rth@twiddle.net,
        shuah@kernel.org, tsbogend@alpha.franken.de, vbabka@suse.cz,
        willy@infradead.org
Subject:  +
 maintainers-add-tools-testing-selftests-vm-to-memory-management.patch added
 to -mm tree
Message-ID: <20210510042126.BDiy9hexO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add tools/testing/selftests/vm/ to MEMORY MANAGEMENT
has been added to the -mm tree.  Its filename is
     maintainers-add-tools-testing-selftests-vm-to-memory-management.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-tools-testing-selftests-vm-to-memory-management.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-tools-testing-selftests-vm-to-memory-management.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: MAINTAINERS: add tools/testing/selftests/vm/ to MEMORY MANAGEMENT

MEMORY MANAGEMENT seems to be a good fit.

Link: https://lkml.kernel.org/r/20210419135443.12822-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-tools-testing-selftests-vm-to-memory-management
+++ a/MAINTAINERS
@@ -11820,6 +11820,7 @@ F:	include/linux/mmzone.h
 F:	include/linux/pagewalk.h
 F:	include/linux/vmalloc.h
 F:	mm/
+F:	tools/testing/selftests/vm/
 
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
_

Patches currently in -mm which might be from david@redhat.com are

perf-map_executable-does-not-indicate-vm_mayexec.patch
binfmt-remove-in-tree-usage-of-map_executable.patch
mm-ignore-map_executable-in-ksys_mmap_pgoff.patch
mm-make-variable-names-for-populate_vma_page_range-consistent.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables.patch
maintainers-add-tools-testing-selftests-vm-to-memory-management.patch
selftests-vm-add-protection_keys_32-protection_keys_64-to-gitignore.patch
selftests-vm-add-test-for-madv_populate_readwrite.patch

