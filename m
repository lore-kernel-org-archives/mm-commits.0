Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD0BC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 06:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240257AbhK2GWA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 01:22:00 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:57355 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbhK2GT7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 01:19:59 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J2Zqq1zHpz4xQv;
        Mon, 29 Nov 2021 17:16:39 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1638166601;
        bh=+0Jwvz0Q7SQtF+0KIajwnCbrX2GkanaoinAM8tgC7Mg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TDeaxtZwOnBXkAc+y1+GmacpXLeo4KWtvbyqFSgdhbbjtTFEMT6ZGMGiAsI5PS+FJ
         WgNPvydPozITmHUrpvf1vgtENSi1z+Ms4Nk7YZ5xa6T2mkL5/di0TrgKXPVfm2a2G5
         FWgdrfE5/l+tkGxGr3m9XjS5shb0CGVFR6OtY47s9FJcABnt8gINfttluCfRxwAvY3
         4kmXKWwmMH50r15+DcBhKrbmU+IPGlsOlF2LP5vt+VdK02ghHuoD8mT1pdpJ2KAAxp
         8zkhv/ywOXECpECDB3Qjpnli6t5NbEdAGhXX66QH4vv1yN1Rop+MoxxmXxH81Onig5
         KKKycPTPY/qqw==
Date:   Mon, 29 Nov 2021 17:16:38 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     ch0.han@lge.com, mm-commits@vger.kernel.org, seanga2@gmail.com,
        tangbin@cmss.chinamobile.com, weizhenliang@huawei.com,
        zhangshengju@cmss.chinamobile.com
Subject: Re: +
 tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling-fix.patch added
 to -mm tree
Message-ID: <20211129171638.24db995e@canb.auug.org.au>
In-Reply-To: <20211128001723.NeHg5hxRP%akpm@linux-foundation.org>
References: <20211128001723.NeHg5hxRP%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_//grfGr2R+qzBcyclLMFeYwL";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_//grfGr2R+qzBcyclLMFeYwL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Sat, 27 Nov 2021 16:17:23 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: tools/vm/page_owner_sort.c: fix NULL-pointer dereference wh=
en comparing stack traces
> has been added to the -mm tree.  Its filename is
>      tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling-fix.patch

Applied to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_//grfGr2R+qzBcyclLMFeYwL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGkcEYACgkQAVBC80lX
0Gwrcwf9HqistplfE90FHc+u3kDH2G94vRG4fQ7ZuJWOxIpqDWjQ9j+dO7eHL+Ry
NC9LkJzDsGtXZLJ5Ti7fohkxCCwZSJn9ujANXcOsYK2CSeNWmxCfr101LTpxQEqL
32GAmgWY6mC1fXmsm6YYOXFG+cDs5l8mw1MfAcq8r5C851w7Opzb8ux6jlerz4YC
XeLXr2sORDkKrraTCTp3jOnfkMZ/sXp3+W/2XdQI1hP+d8Gq3xUWBbrhSSUREQr5
hZ0c/TSPjVkBjmdVEME+EYUhSEQpfDnDkqLMs0+0JrtxAvS/cFQ6jiudLaj7hwTL
wP08zYhAFTn+OHVl0kn04l8ryKMSMQ==
=uX/t
-----END PGP SIGNATURE-----

--Sig_//grfGr2R+qzBcyclLMFeYwL--
