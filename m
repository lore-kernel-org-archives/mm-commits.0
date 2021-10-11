Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C204BC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 11 Oct 2021 22:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A09CA60F11
	for <mm-commits@archiver.kernel.org>; Mon, 11 Oct 2021 22:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhJKWwa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Oct 2021 18:52:30 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:49171 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhJKWw3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Oct 2021 18:52:29 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HSvC719rJz4xbV;
        Tue, 12 Oct 2021 09:50:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1633992628;
        bh=Neo3fyZmzLB/Lyu05OshU1l0In5NiCBHcagUFf2fQbc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VbBVjJbssA89y4vxKFgxTSpLoDwyFitZYh8aFdPcomLvq7mgwsysORCBu8wZSzkaO
         RB0L4vT9zKcuoY6rruQHOw4NldBv/lW6+KyKL2UAPfAorA4WVnDYFPS3JIVJ5u7ETM
         NX7FfhU72ohvNpQ6dr60lr1W0j0LiAy4WSlgxRT8YYjw8X/5nBCSE52UJa52O8JTT4
         OgZdoOfNJImumDciL8+6KDWICWQDTTGcQwSBdPnDWZyYyN7DUS+U9c+BlGo5SMmzMf
         l4Kci4UVQu3FYUMjJR/C4AJM/+WjVUU7xuCLeF7GTkMuXl8Mc/00b6GtrIzNjzNNqY
         bgGHaifW8B7DA==
Date:   Tue, 12 Oct 2021 09:50:25 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     catalin.marinas@arm.com, dvyukov@google.com, lkft@linaro.org,
        mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        ryabinin.a.a@gmail.com, wangkefeng.wang@huawei.com
Subject: Re: +
 kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc-fix.patch
 added to -mm tree
Message-ID: <20211012095025.042ac131@canb.auug.org.au>
In-Reply-To: <20211011205642.MrLcZAmUS%akpm@linux-foundation.org>
References: <20211011205642.MrLcZAmUS%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/RlvW.8SPupDDcLgMCgY0Vy1";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/RlvW.8SPupDDcLgMCgY0Vy1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 11 Oct 2021 13:56:42 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm: kasan: fix redefinition of 'kasan_populate_early_vm_are=
a_shadow'
> has been added to the -mm tree.  Its filename is
>      kasan-arm64-fix-pcpu_page_first_chunk-crash-with-kasan_vmalloc-fix.p=
atch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/RlvW.8SPupDDcLgMCgY0Vy1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFkv7EACgkQAVBC80lX
0GyzYAf8COBSk5ltqGvYjji19iMUjDs+rA6Gn/3SnPH/EOjgqdlCCB4NRf05bQps
I7En8iNEfCBLQu71RL1Wupd4peTE2bAQcSGMKDqOVPgS1wB+em2FG2koyN6zyqyr
2XwWONR4NHe3Y15gyNstLMTPjowjac2mXFzcfgq4htV8RnNMBv3RtSW5wIWjYuJV
+vcStwKcuUNz1Gtwr69rV1+CKN3z0GWsae+/A62HLed+7JdDlzMUyQu9tgdhHbpe
yd1JIizqxUoDfHiEGWxh6Qw5U4NkjvoxTvPdijKbHYvr+D7bI6g0dAL3vWZxRInP
CCaZI4+pwTAgPOh7MX0ky+6jWE8hNw==
=+sjG
-----END PGP SIGNATURE-----

--Sig_/RlvW.8SPupDDcLgMCgY0Vy1--
