Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA85C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 29 Jan 2022 03:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351757AbiA2D1u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Jan 2022 22:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241047AbiA2D1u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jan 2022 22:27:50 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE6CC061714
        for <mm-commits@vger.kernel.org>; Fri, 28 Jan 2022 19:27:49 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Jm0Bk4STYz4xcQ;
        Sat, 29 Jan 2022 14:27:42 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1643426868;
        bh=OWu74g4jzaXI0vieI7NOjz8iriR0MAD19f6q72i7Pxw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pk3qLpz9pc69daXsWR4nLLzTK4GMikEzTxu/l7SvMr+b4X70dwOZziIRw35BTj3pR
         BIgokJZ8lEAMa7QoecSDGX/+Y+rPHZMyWwJtVBPX658FOnXjdzd9/KTYOe+KPzGp2/
         e/zYjQBjBFP4N4OB6liNSKKZPRWD2Hve1nvgQcE40zWiqpA/Ilk1uoehslxlEIa0Ss
         7FB4nk0AhnEovOpqxK0Z+8cjX2+IR4oRzt20AJx4bT4k7HlWJqWrVBCC9mSWHNsKtS
         mz1ABvemAqA78WVhv+KsyctfnS3iKDiJhMXSbW/KiGoPwE9Ls3wk475DRYKgevsIIz
         pRXlHwYMj0sgw==
Date:   Sat, 29 Jan 2022 14:27:41 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        rmk+kernel@armlinux.org.uk, paul.walmsley@sifive.com,
        palmer@rivosinc.com, palmer@dabbelt.com, mingo@redhat.com,
        linux@armlinux.org.uk, hpa@zytor.com, ebiederm@xmission.com,
        dave.hansen@linux.intel.com, catalin.marinas@arm.com, bp@alien8.de,
        bhe@redhat.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
        jszhang@kernel.org
Subject: Re: [failures]
 arm-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch removed from -mm
 tree
Message-ID: <20220129142741.57813001@canb.auug.org.au>
In-Reply-To: <20220128213750.MIW5R%akpm@linux-foundation.org>
References: <20220128213750.MIW5R%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ju1MXK6U6t.Zx1CFJNjtAfr";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/ju1MXK6U6t.Zx1CFJNjtAfr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 28 Jan 2022 13:37:50 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: arm: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef
> has been removed from the -mm tree.  Its filename was
>      arm-use-is_enabledconfig_kexec_core-instead-of-ifdef.patch
>=20
> This patch was dropped because it had testing failures

Removed from the linux-next akpm-current tree as well.

I clearly need to remember to read all my email before replying :-)
--=20
Cheers,
Stephen Rothwell

--Sig_/ju1MXK6U6t.Zx1CFJNjtAfr
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmH0tC0ACgkQAVBC80lX
0GzfJAgAjwk4Eni9m/F4cnS8o1NRQoUNB/nKxLwRZgByVDtHmTWxNZhSQahd3EW4
vYbY8wc7ho52PloS7MR4oiHxmmqHOU/1wHYfcVKvoRo/GkpHi96k4xvOf23wieFR
1Egg3gbEqZ9NbS/mENIddViw/1EYnAeCFsMdemENhZ0A+2ih6JMxl3JUf4OV67VS
6riUl7aQbXQLYIm4Hqm7PWUvE1PoJViqW9T+X0ggsWENtFeaD4SJCoHOB84n1ud1
jUbL3hmM7aSdgiGlCPH3PhS7nhNcKTmdUA1Ns3Cmjhwbq9A23rx2tbzYRLY0T2oN
d82C+RUhCkd+AnTZrUEtCNP5VC7V2g==
=VY5H
-----END PGP SIGNATURE-----

--Sig_/ju1MXK6U6t.Zx1CFJNjtAfr--
