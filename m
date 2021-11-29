Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CE8DC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 06:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhK2GWd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 01:22:33 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:41279 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbhK2GUd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 01:20:33 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J2ZrW2nVgz4xR9;
        Mon, 29 Nov 2021 17:17:15 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1638166635;
        bh=usStC8DuXH08vMaYcb3SSLuSNheUMZNwLIj39VaH32g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jV6mImCtev9J2tFVJqDX98ZAMU83Bi5JN9Xr7b9ic6pCKh2grs7nkmtXAOOT9Ev5A
         x93ysvK8NStDiCyLfCUSsZhy8pTjmnqOUfbA21tcM3w/2putYgM5O6By+35YnZdbmH
         OJ7ab0zFNzFf6e3ggJ8uGBy9tyoMxrwU/oewNjdB63r4TVbLYJzYa1XRTILOSjxl/T
         /3uPQHBO2YfOyZRecz/vfADXIU3Gr2tIfTUywd1HwL/tCGTW6graw3xFKMkSoo5q/v
         Jp69ivBWfH3AtIqn1wYearwRD1QtkHKWMiCtVeTe9obPOd5jqDaHR/LbYSZ5D3DIPs
         OLsKxKA+f9jhQ==
Date:   Mon, 29 Nov 2021 17:17:14 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     joao.m.martins@oracle.com, mm-commits@vger.kernel.org
Subject: Re: +
 device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud-fix.patch added to
 -mm tree
Message-ID: <20211129171714.07687831@canb.auug.org.au>
In-Reply-To: <20211128003513.txuq1mGQQ%akpm@linux-foundation.org>
References: <20211128003513.txuq1mGQQ%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/.dJ.IR3qo8GTlbGY=.t0qw6";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/.dJ.IR3qo8GTlbGY=.t0qw6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Sat, 27 Nov 2021 16:35:13 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud-fix
> has been added to the -mm tree.  Its filename is
>      device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud-fix.patch

Applied to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/.dJ.IR3qo8GTlbGY=.t0qw6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGkcGoACgkQAVBC80lX
0GzxTAf/QVBTTOPR5OxpEjSX4dzPXLC9QwN2/80CbfVuCb31HrnWA+jFE5Cxc8VF
LuD6y93owRCm92Z1dTsWo1v/LmwkX2UBzBj3PwRmiohYsVofgifMGI5N4rCtCX1M
wzP+sd2ZUVJK+2kMevbfPXTVcNITDD0CljssZozBbQDAwo2eLG4tElEoAEQ9cdXS
dbvdu5uXgzclJ07jZFeWxExrqeIz5ai6c0alENJLdzdNDs8V7+VJB9comA53150L
w9ad78zv15M++sNm8O7/8COGz/cx3O23vsgonrDc0c09PqFLrl+pnFZY2J+oJQeg
EcIxwp82swIUn/eWjTuXTSn9o3vAJw==
=IBbj
-----END PGP SIGNATURE-----

--Sig_/.dJ.IR3qo8GTlbGY=.t0qw6--
