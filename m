Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B81C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 31 Oct 2021 02:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0514A60D07
	for <mm-commits@archiver.kernel.org>; Sun, 31 Oct 2021 02:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhJaCIn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 30 Oct 2021 22:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhJaCIm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 30 Oct 2021 22:08:42 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79EDC061570
        for <mm-commits@vger.kernel.org>; Sat, 30 Oct 2021 19:06:11 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hhff95ZfGz4xZ1;
        Sun, 31 Oct 2021 13:06:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1635645970;
        bh=nQJDBR155+1X/sDnu9KZ2+rdYCNZv19UOqsgOMReHkY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RlKx8d6xvu36aBSTARCjFfwykalEsMkQBoZFXE2ZflhWj5mj/ovwi9XQaCaJet+5A
         bgk8r9G20WTNXet2ewxivBIUY/nxOTq5RfNHoIwz8AX07UE2OkgX7m3TnwTHKqFU2W
         wtU9og1/fQQ/OZFbDPE2r13l4ZBNMO+LEBNZfe5hZT61j6GYR9sds1RhOzmnLKhzK9
         Glgk0MvK5qJXDgLz23kh1V0z+Q3rFABG3IcBKFNBEPrfV/sfeNQErmKNZGodXXyvft
         QmofZjyw5LPrFsyJG5yr7scZdqGyFax6qPUbN9VISOvnfKvcmNELFo4Skv2XjqQMXW
         TozoPQK4cRaGw==
Date:   Sun, 31 Oct 2021 13:06:08 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org
Subject: Re: + kernelh-split-out-instruction-pointer-accessors.patch added
 to -mm tree
Message-ID: <20211031130608.3fb5c415@canb.auug.org.au>
In-Reply-To: <20211028192443.ScBAdmcmI%akpm@linux-foundation.org>
References: <20211028192443.ScBAdmcmI%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/U/u0u+ZJ5PXvmLzCknErLFR";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/U/u0u+ZJ5PXvmLzCknErLFR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 28 Oct 2021 12:24:43 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: kernel.h: split out instruction pointer accessors
> has been added to the -mm tree.  Its filename is
>      kernelh-split-out-instruction-pointer-accessors.patch

This was added to linux-next on Friday.

--=20
Cheers,
Stephen Rothwell

--Sig_/U/u0u+ZJ5PXvmLzCknErLFR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmF9+hAACgkQAVBC80lX
0Gzy2AgAgndEspwSljJAiKrxYK9gU1hkm859QMxY5btbiC4ZsYKUsun38tKcYLjb
S1zeSDL8n6Fl3xBES1+U/fDWR7yEHmy3u6RYjslkBPpfNgMtFqK5ARIXi61YM78y
ZUfUr2r1K/JfDmD4+ijDnks0BFrU6eb6Vra62EjWXqSh/C/Urcl1BVNTpdy74//L
q44opCIWDbNT6MZwDdk42Nke69OYte+0AKsJ2k25wSWxTt1KgxXVxfXwGutodwLm
flbkRSWhsdFG06PLE5oMj2t0zRObKja+6Qe8Uk1gOrO3MId+YfTDRqhJ1SLvMTFt
LyJBmSh1lZQm2GQckVKW24ihWUNssg==
=/NND
-----END PGP SIGNATURE-----

--Sig_/U/u0u+ZJ5PXvmLzCknErLFR--
