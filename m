Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BC3C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 12 Oct 2021 21:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D77C610A2
	for <mm-commits@archiver.kernel.org>; Tue, 12 Oct 2021 21:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhJLVHk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Oct 2021 17:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbhJLVHj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Oct 2021 17:07:39 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD8DC061570
        for <mm-commits@vger.kernel.org>; Tue, 12 Oct 2021 14:05:37 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HTSqb528bz4xbR;
        Wed, 13 Oct 2021 08:05:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1634072732;
        bh=s1y1zLagvkddajPku+x5fQBOOCoBs3xagm98wRY4BuI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f6i5zdR3PpGr6//k5t3zYYY9jxnK7Z+JPpq6BNB4Rme54ZXvnv4R1IS/uCyOU6vie
         M4yOWTUpR7RztQkU7b5WZmsejjSls+IJ216kag/tEFHiADMfa6+a4AjmHRqbJvvEHt
         I39e6EVmckmeC+k+K5mRJ4fluWLue+whENF0RHDepe0UFJz6uIvyBItA+MyzQ9B3UL
         3BPMRL5hHMmJc1ncgOd0qBndmA11MfHA4VctZ6IS6mks7VCa4BQ/kaooaGkthS+Oe1
         TrDE+YGpsOAkKwWuzbheEBxhdXHzsGjzRVvCiJyd4k+20OPPsFTKmxFbNTdFJkVVXG
         cudb6v4BNXCbg==
Date:   Wed, 13 Oct 2021 08:05:25 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     keescook@chromium.org, mm-commits@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, willy@infradead.org
Subject: Re: +
 compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch
 added to -mm tree
Message-ID: <20211013080525.68d46e3a@canb.auug.org.au>
In-Reply-To: <20211012205610.Os8RABpiO%akpm@linux-foundation.org>
References: <20211012205610.Os8RABpiO%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/2Sh4TM+JDpUYVrtBySaH8za";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/2Sh4TM+JDpUYVrtBySaH8za
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, 12 Oct 2021 13:56:10 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: scripts: kernel-doc: Ignore __alloc_size() attribute
> has been added to the -mm tree.  Its filename is
>      compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.=
patch

This patch has been added to Jon Corbet's tree today.

--=20
Cheers,
Stephen Rothwell

--Sig_/2Sh4TM+JDpUYVrtBySaH8za
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFl+JUACgkQAVBC80lX
0Gzmagf/U2JDc9Flqz2BSUWg0VUdcko5kCdlBeiWHd+xq3OnAuZ1hifADge7IUgc
W8B81NOcAJgYrhZ1HkLVurli8s1bDjy55WkQrX1r/aMg4wnJCSgfAAB8+BO58k2n
6mLdtaFc6eIe5mqTw2SerIM0smyiG/8Vy2JjX04V6qLIj89hy0eeTNSsOvVV9WQ2
sZTsdbAWoLeqGBz6iIaCAcEgdX3wa0l9oxTp5IznU0bIX5MhU2ykT7VQMcDiamkK
AbRBHz+FMf+PuWPxSARQQ4/kfYsHATJP9uQyqfNazzJiM6uAsmE61hrNClZv5lnL
NSw3AAURBB5IJtInNP06yIjvR6gIXA==
=G1D8
-----END PGP SIGNATURE-----

--Sig_/2Sh4TM+JDpUYVrtBySaH8za--
