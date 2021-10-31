Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C582C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 31 Oct 2021 02:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9CC160D07
	for <mm-commits@archiver.kernel.org>; Sun, 31 Oct 2021 02:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhJaCIH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 30 Oct 2021 22:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhJaCIG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 30 Oct 2021 22:08:06 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7935DC061570
        for <mm-commits@vger.kernel.org>; Sat, 30 Oct 2021 19:05:35 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HhfdP4nWxz4xZ1;
        Sun, 31 Oct 2021 13:05:29 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1635645930;
        bh=megs+l2oHIrT6BgTJCfKJ91XwaOdniRTdAQAEJgPiYc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R8//wG9Ejpy5kjG7iG0YJGPNkk/z14jjQnX7qr2OsxUlK4EakY0V/72Dv3piZ2QyW
         Mh61/0x0oHgrIuQxIGwTO5jqsF8yFxqxesB5zsyhcB56HpH8foUTeB0gyyzuXTnbrx
         kFBXb9njGmzAKActkTAkuCUhTiZhWrlvSTG7VUz5KJYwGUNt45oWCrZ1q4qwvxuY4s
         shHWb/JMmzTf30PZ6KTHvNvUmhP8Fdwk2ESE5M5WkmAp9M8gPzLxE+zNMKpIu0lp7q
         jmTGyE3Z0l280oaJPMoIh2lwlT3rOTRgazycFREPY/CkNhWQQv3DpCq/gCSo1kL5MV
         8enQE05P1qQeA==
Date:   Sun, 31 Oct 2021 13:05:27 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     andriy.shevchenko@linux.intel.com, linux@roeck-us.net,
        mm-commits@vger.kernel.org
Subject: Re: +
 delay-replace-kernelh-with-the-necessary-inclusions-fix-2.patch added to
 -mm tree
Message-ID: <20211031130527.21198354@canb.auug.org.au>
In-Reply-To: <20211028192331.TXDKRLEIf%akpm@linux-foundation.org>
References: <20211028192331.TXDKRLEIf%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/cD/7Uisy+gaYRwS6Ks8I/52";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/cD/7Uisy+gaYRwS6Ks8I/52
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 28 Oct 2021 12:23:31 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: delay.h: fix for removed kernel.h
> has been added to the -mm tree.  Its filename is
>      delay-replace-kernelh-with-the-necessary-inclusions-fix-2.patch

This was added to linux-next on Friday.

--=20
Cheers,
Stephen Rothwell

--Sig_/cD/7Uisy+gaYRwS6Ks8I/52
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmF9+ecACgkQAVBC80lX
0GxMeQf9FHCsUymoR3l9F+cJecp5Z6g+Dp7pnVwPnRkbXT6S3Bgtx2xNOt61bFky
mKLk6bi6nUy7nsGwCjnyRqemRELfm5nh9W5pAZ3w91JKxg0Xr25mK4yrDluQbDbl
tJd/HZ7TjtfL7GHFaRJY7OVX9x3cUP0t/TwwCGsZcg/m+3AZDC7dhmm6Ivw6d8BG
acPGOdTz4hopLdq+cH2LAfdsqMtxqXb/RwjdtjlDDEQlKfbYwkHsCa1DZP4LC5hD
pCEj3YIrUg/+rWN9IGkshEVzgQ6jAeMKBIUfQ5DFDqXXGuH8Hxc/q/y+eGFH9yEM
uSr0uU0UvTjiycWsb+EZAkYBKq0hDg==
=s3vE
-----END PGP SIGNATURE-----

--Sig_/cD/7Uisy+gaYRwS6Ks8I/52--
