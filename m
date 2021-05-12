Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24912C43470
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 23:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C16D613C0
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 23:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347258AbhELXdx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 19:33:53 -0400
Received: from ozlabs.org ([203.11.71.1]:51141 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232412AbhELXOA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 19:14:00 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FgVtx3r9Rz9sTD;
        Thu, 13 May 2021 09:12:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1620861167;
        bh=l8tsPajG5xcCFCmI4CWEubDvjGpqIe/reeWRfOvcH7s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lziy5N+dl9qFsfQ7FbfPrTMXgtJnaREtz9U+qcUw60RsCqalM+5BgATXhAE7vRpOk
         GtIeceQ8j3Xe7g/5nuLC+LkV1Z6Q8LsNXr6LbXJpuKktFwua4Hf4qYf96cxd+mU8l1
         XT8G405eae6Dg8i50uHjx4O4nbW5z4Mo+Npv1vpcRDUr0QF3STs13PrsnObyTNen2h
         lIXiDd5S4Mb0XiLUluELIYHaBJBdYgx2Htivhhawt3o1W4i7faxCyupcT8xMKsakn8
         jd0HKtZ1zkscPnZ7cWLNXRF5tU9KEB6eeYVoaqHK9L1oWxM3qNPr8ygOaeuSztExsJ
         ExBderxMF7O7w==
Date:   Thu, 13 May 2021 09:12:40 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     aarcange@redhat.com, almasrymina@google.com,
        axelrasmussen@google.com, bgeffon@google.com, dgilbert@redhat.com,
        hughd@google.com, jglisse@redhat.com, joe@perches.com,
        kirill@shutemov.name, lokeshgidra@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        oupton@google.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        shli@fb.com, shuah@kernel.org, viro@zeniv.linux.org.uk,
        wangqing@vivo.com
Subject: Re: [withdrawn]
 userfaultfd-hugetlbfs-avoid-including-userfaultfd_kh-in-hugetlbh.patch
 removed from -mm tree
Message-ID: <20210513091240.35a0c176@canb.auug.org.au>
In-Reply-To: <20210512222309.YOT37EwET%akpm@linux-foundation.org>
References: <20210512222309.YOT37EwET%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/zTIkXvgWsZQSX4DcPFTZgwC";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/zTIkXvgWsZQSX4DcPFTZgwC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 12 May 2021 15:23:09 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: userfaultfd/hugetlbfs: avoid including userfaultfd_k.h in h=
ugetlb.h
> has been removed from the -mm tree.  Its filename was
>      userfaultfd-hugetlbfs-avoid-including-userfaultfd_kh-in-hugetlbh.pat=
ch
>=20
> This patch was dropped because it was withdrawn

Removed from linux-next.

--=20
Cheers,
Stephen Rothwell

--Sig_/zTIkXvgWsZQSX4DcPFTZgwC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCcYOgACgkQAVBC80lX
0GyvAAf+JnvpEejT0IkWE0Grnls5xjoJcaUUReFpI/JRcryLXzKoCz7fJV6v/ESs
XIBXjZUdUYfaVWh1ivRw4OO7/3KRP7YGfhHT1Sd7fLZY4j0MIDytY7Ka2wusgb8O
vH4+M0pHijOY/IBUlfDDPwyKgGpo/V5siG4glZ4RT8kb2GWEspsAqU+y710XJGNW
pZFETD2VJji3NRj766NC9jU3SgG7nVw4XCbwT5RN0ELcxZwsDbppbqOSj/CkrNhZ
iyaf0vofas2rkKzbg4/O9S74pPdwnIa0Lg2CbnBkHftk1uJBMr+zLyiiXPghVH3n
uO0KLWtY4olacxPq4eG0zOHTkGnUZA==
=YCfM
-----END PGP SIGNATURE-----

--Sig_/zTIkXvgWsZQSX4DcPFTZgwC--
