Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A589C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B74222D02
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgLPAAO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:32844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbgLOX1P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:27:15 -0500
Date:   Tue, 15 Dec 2020 15:17:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074234;
        bh=i1ZszFZSTbe2yY/1x+1iH5779iS+yQ6ZktZQroezhtE=;
        h=From:To:Subject:From;
        b=VGGi85sjBS3U89vNUnTt4OfOpNimpieADGC989IbpZtjrj+2KFvHgQHofvAqt5aD5
         D0T48Bvp7ckeBXY2gCBzuA9FbyCmi4fNDJvYNcaSHJJP17Y3mX99DHJwZKhWryyB4C
         DUC5o+Bqse7B+wlYNXr9mXW9FyNRAhrkS89ykwBQ=
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, jglisse@redhat.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org
Subject:  [merged]
 selftests-vm-rename-run_vmtests-run_vmtestssh.patch removed from -mm tree
Message-ID: <20201215231714.EpJdlGhIX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: rename run_vmtests --> run_vmtests.sh
has been removed from the -mm tree.  Its filename was
     selftests-vm-rename-run_vmtests-run_vmtestssh.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/vm: rename run_vmtests --> run_vmtests.sh

Rename to *.sh, in order to match the conventions of all of the other
items in selftest/vm.

The only reason not to use a .sh suffix a shell script like this, might be
to make it look more like a normal program, but that's not an issue here.

Link: https://lkml.kernel.org/r/20201026064021.3545418-4-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/Makefile~selftests-vm-rename-run_vmtests-r=
un_vmtestssh
+++ a/tools/testing/selftests/vm/Makefile
@@ -73,7 +73,7 @@ TEST_GEN_FILES +=3D virtual_address_range
 TEST_GEN_FILES +=3D write_to_hugetlbfs
 endif
=20
-TEST_PROGS :=3D run_vmtests
+TEST_PROGS :=3D run_vmtests.sh
=20
 TEST_FILES :=3D test_vmalloc.sh
=20
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

secretmem-test-add-basic-selftest-for-memfd_secret2-fix.patch

