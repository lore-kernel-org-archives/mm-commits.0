Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B7E0C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 04:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA06161409
	for <mm-commits@archiver.kernel.org>; Wed, 29 Sep 2021 04:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbhI2E1S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Sep 2021 00:27:18 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:50959 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhI2E1R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Sep 2021 00:27:17 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HK3Fp21xLz4wgv;
        Wed, 29 Sep 2021 14:25:34 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1632889534;
        bh=c7nvMdGmD9UFlwbuXNHeDTRm1a8pncmw6CS7nZg6luU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UawJ/X+uJtLmC8dHv4Mlv9iKTuWsA88WTjI0Dh9OOTy6sv/n9nURFN5fydQgY1wZK
         vdQANrxXmwwaHhITtNLHARUQSZ9LTbTq6czUmS1luEfHRVJqXKqXJ1XfKWi+WU4+Oo
         gwG9UD/xp/cJ8EEbEI5BAI1yxt5Ya243gJsALG+KBPdL5ZSgSoVik1lrRm10JEDrlm
         NkD0rFlVSUg7Pq0DUxelLG3ooDU9jhWcTtUoL56/ajPCOmkoH8XlWwr5Y2KMut+tLh
         tfNV3Sfocdx4CXm+ZC9UQ7ehsDkZEp01wn+TuXU76DqFLBwiMJL1w4+qNPw/dxNEjT
         8JwzrP+/+duQw==
Date:   Wed, 29 Sep 2021 14:25:33 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     dvyukov@google.com, elver@google.com, glider@google.com,
        jannh@google.com, mm-commits@vger.kernel.org, nogikh@google.com,
        tarasmadan@google.com
Subject: Re: +
 kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix-fix.patch
 added to -mm tree
Message-ID: <20210929142533.1ce8d79b@canb.auug.org.au>
In-Reply-To: <20210929032540.vi1QD7Ofp%akpm@linux-foundation.org>
References: <20210929032540.vi1QD7Ofp%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/tAi7JjNezwBcwyHy+QuXx7K";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/tAi7JjNezwBcwyHy+QuXx7K
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, 28 Sep 2021 20:25:40 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: kfence-limit-currently-covered-allocations-when-pool-nearly=
-full-fix-fix
> has been added to the -mm tree.  Its filename is
>      kfence-limit-currently-covered-allocations-when-pool-nearly-full-fix=
-fix.patch
>=20
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/kfence-limit-currently-cove=
red-allocations-when-pool-nearly-full-fix-fix.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/kfence-limit-currently-cove=
red-allocations-when-pool-nearly-full-fix-fix.patch

added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/tAi7JjNezwBcwyHy+QuXx7K
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFT6r0ACgkQAVBC80lX
0GyLsQf+OU9g/rorqHxLdoTGHCCmoRHyt5m5wXjGCynd1zFuGNAqlQtuH5JhNLUU
5lX2W/jHOP9YZweaFW51jUKAd+zLIVs1zqQftNMSGFMS8oF4sG5PtVlDMTV8wr83
SrARtzvKdRvwZ89XRwb5Sna6CpSeYnULvm3U8YHTtNEGBzWQzMJhDyy1i/9OlhxK
aS5uwo/UMZb7Z7Ly/3SkEkfXx4OyICFAFZFOO3mBcmWYSGoQ5duZmijFkxXdt++o
hABNQszaMDfzrQyXLp1rEJ9yiv+Iie8sv9F2ogmaUqIvTEioeUu6w/DlLrclm/SQ
rRgLZotJZIhmbfBH2NzQJyGz2vLfsg==
=DXD6
-----END PGP SIGNATURE-----

--Sig_/tAi7JjNezwBcwyHy+QuXx7K--
