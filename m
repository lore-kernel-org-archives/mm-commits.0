Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C50C433B4
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 23:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56661613C0
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 23:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242980AbhELXdm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 19:33:42 -0400
Received: from ozlabs.org ([203.11.71.1]:44043 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238435AbhELW5O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 18:57:14 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FgVWl26C3z9sWP;
        Thu, 13 May 2021 08:56:03 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1620860163;
        bh=AFieOrap/bAGKx4G+i1fYXBtafNIf2Jk359lVe65Uec=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nign2jnjoJXcbme9ZPb8sFciqQyXL/ZUr0jlabv/8hNZ9cwNTnfxNC4feEc881Izt
         VaxcE6m/uNdNohRwJsno9ZHSXp5ZgNPuWT/f1Lg+EyRUbfQuNkiAsVEeg7N0KhYiRw
         C8Al+Exe/P2+zH0kIMcNRtiR6+/jw4nbs83PVuOBOOEQzEUYKx1P/iDb9FyyF/mOyC
         7mCQuAaym7oEk8zXiOpg7egIGTH+I6d25f1uBfGdJpge/kbxHWThwjJ1H0+krnTkvw
         wKx1U4n3NYy9nB4ROwhYsaso6PMFwRKNwnYxHRUx6kTDXzY/ESkhoPwrrwXlf7HuiG
         7DMXeOTS95r3w==
Date:   Thu, 13 May 2021 08:56:02 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     hdanton@sina.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        urezki@gmail.com, willy@infradead.org
Subject: Re: [failures]
 mm-vmalloc-print-a-warning-message-first-on-failure.patch removed from -mm
 tree
Message-ID: <20210513085602.6d3f9d63@canb.auug.org.au>
In-Reply-To: <20210512202952.PRR7JClh8%akpm@linux-foundation.org>
References: <20210512202952.PRR7JClh8%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/TM3AdtxnnA=mf9_JnS72NeB";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/TM3AdtxnnA=mf9_JnS72NeB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 12 May 2021 13:29:52 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm/vmalloc: print a warning message first on failure
> has been removed from the -mm tree.  Its filename was
>      mm-vmalloc-print-a-warning-message-first-on-failure.patch
>=20
> This patch was dropped because it had testing failures

Removed from linux-next.

--=20
Cheers,
Stephen Rothwell

--Sig_/TM3AdtxnnA=mf9_JnS72NeB
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCcXQIACgkQAVBC80lX
0Gxi5Af9GX6j5ffxN3ov3KdewmVyYeNj9RhaMb92lrIoDpXBqFHfNrmr88ACbkYn
FYGVyAs2iS9veyzvacOc2PSXwCatTNtMndGaP87vo50R9Lrtw11XQ7kPq2mPyn7z
w0JqtKGNvjWWiNYotPGVqXRFsfUGbvDJ9wurwzwkDQW5KpDNoUDH5j/LKvvPPaKp
4AIntxSELSiciFDGp2BNf+ZEt4GNHk4DPPhivqXuJb8wIIJgugUtF5vZWIGkt0vj
21OVv6uiqzZ1iiJ6rLwJY7+gnDIEbFiFC53JrfMlPV+sAHKJ2LyHvCIagUR561H3
bxA7UVZCWC8pvHvvWe6Hyz+D1I9Y0Q==
=XBkU
-----END PGP SIGNATURE-----

--Sig_/TM3AdtxnnA=mf9_JnS72NeB--
